// excel.ts
//
// usage:
//
// CSV一括書き込み
// deno run -A excel.ts write-csv sample.xlsx Sheet1 data.csv
//
// セル読み取り
// deno run -A excel.ts read sample.xlsx Sheet1 A1
//
// dump
// deno run -A excel.ts dump sample.xlsx Sheet1
//
// CSV:
// A1,名前
// B1,年齢
// A2,田中
// B2,30,number
// C2,true,boolean

import { readFile, utils, writeFile, WorkBook, Sheet } from "npm:xlsx";

const args = Deno.args;

if (args.length === 0) {
    help();
    Deno.exit(1);
}

const cmd = args[0];

switch (cmd) {
    case "write-csv":
        await writeCsv();
        break;

    case "read":
        readCell();
        break;

    case "dump":
        dumpSheet();
        break;

    default:
        help();
        Deno.exit(1);
}

function help() {
    console.log(`
write-csv:
  deno run -A excel.ts write-csv <xlsx> <sheet> <csv>

read:
  deno run -A excel.ts read <xlsx> <sheet> <cell>

dump:
  deno run -A excel.ts dump <xlsx> <sheet>
`);
}

function openWorkbook(path: string): WorkBook {
    try {
        return readFile(path);
    } catch (e) {
        console.error(`Warning: Failed to read ${path}: ${e instanceof Error ? e.message : String(e)}`);
        return utils.book_new();
    }
}

function getOrCreateSheet(workbook: WorkBook, sheetName: string): Sheet {
    let sheet = workbook.Sheets[sheetName];

    if (!sheet) {
        sheet = utils.aoa_to_sheet([]);
        utils.book_append_sheet(workbook, sheet, sheetName);
    }

    return sheet;
}

function validateCell(cell: string): boolean {
    try {
        utils.decode_cell(cell);
        return true;
    } catch {
        return false;
    }
}

function updateRange(sheet: Sheet, cell: string): void {
    if (!sheet["!ref"]) {
        sheet["!ref"] = `${cell}:${cell}`;
        return;
    }

    try {
        const range = utils.decode_range(sheet["!ref"]);
        const target = utils.decode_cell(cell);

        range.s.r = Math.min(range.s.r, target.r);
        range.s.c = Math.min(range.s.c, target.c);

        range.e.r = Math.max(range.e.r, target.r);
        range.e.c = Math.max(range.e.c, target.c);

        sheet["!ref"] = utils.encode_range(range);
    } catch (e) {
        throw new Error(`Failed to update range for cell ${cell}: ${e instanceof Error ? e.message : String(e)}`);
    }
}

async function writeCsv(): Promise<void> {
    const xlsxPath = args[1];
    const sheetName = args[2];
    const csvPath = args[3];

    if (!xlsxPath || !sheetName || !csvPath) {
        throw new Error("write-csv requires 3 arguments: <xlsx> <sheet> <csv>");
    }

    // Read CSV file
    let csv: string;
    try {
        csv = await Deno.readTextFile(csvPath);
    } catch (e) {
        throw new Error(`Failed to read CSV file ${csvPath}: ${e instanceof Error ? e.message : String(e)}`);
    }

    const workbook = openWorkbook(xlsxPath);
    const sheet = getOrCreateSheet(workbook, sheetName);

    const lines = csv
        .split(/\r?\n/)
        .map(v => v.trim())
        .filter(Boolean);

    let processedCount = 0;
    const errors: string[] = [];

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        const cols = line.split(",");

        const cell = cols[0]?.trim();
        const rawValue = cols[1]?.trim();
        const type = (cols[2]?.trim() ?? "string").toLowerCase();

        if (!cell || rawValue === undefined || rawValue === "") {
            continue;
        }

        // Validate cell reference
        if (!validateCell(cell)) {
            errors.push(`Line ${i + 1}: Invalid cell reference "${cell}"`);
            continue;
        }

        let value: string | number | boolean = rawValue;
        let cellType: "s" | "n" | "b" = "s";

        try {
            switch (type) {
                case "number":
                    value = Number(rawValue);
                    if (isNaN(value)) {
                        errors.push(`Line ${i + 1}: Cannot parse "${rawValue}" as number`);
                        continue;
                    }
                    cellType = "n";
                    break;

                case "boolean":
                    if (!["true", "false"].includes(rawValue.toLowerCase())) {
                        errors.push(`Line ${i + 1}: Boolean value must be "true" or "false", got "${rawValue}"`);
                        continue;
                    }
                    value = rawValue.toLowerCase() === "true";
                    cellType = "b";
                    break;

                default:
                    cellType = "s";
                    break;
            }

            sheet[cell] = {
                t: cellType,
                v: value,
            };

            updateRange(sheet, cell);
            processedCount++;
        } catch (e) {
            errors.push(`Line ${i + 1}: ${e instanceof Error ? e.message : String(e)}`);
        }
    }

    // Write workbook
    try {
        writeFile(workbook, xlsxPath);
    } catch (e) {
        throw new Error(`Failed to write ${xlsxPath}: ${e instanceof Error ? e.message : String(e)}`);
    }

    console.log(`✓ Updated ${xlsxPath} (${processedCount} cells written)`);
    if (errors.length > 0) {
        console.log(`⚠ Warnings (${errors.length}):`);
        errors.forEach(err => console.log(`  ${err}`));
    }
}

function readCell(): void {
    const xlsxPath = args[1];
    const sheetName = args[2];
    const cell = args[3];

    if (!xlsxPath || !sheetName || !cell) {
        throw new Error("read requires 3 arguments: <xlsx> <sheet> <cell>");
    }

    if (!validateCell(cell)) {
        throw new Error(`Invalid cell reference: ${cell}`);
    }

    let workbook: WorkBook;
    try {
        workbook = readFile(xlsxPath);
    } catch (e) {
        throw new Error(`Failed to read ${xlsxPath}: ${e instanceof Error ? e.message : String(e)}`);
    }

    const sheet = workbook.Sheets[sheetName];

    if (!sheet) {
        throw new Error(`Sheet not found: ${sheetName}`);
    }

    const value = sheet[cell]?.v ?? "";
    console.log(String(value));
}

function dumpSheet(): void {
    const xlsxPath = args[1];
    const sheetName = args[2];

    if (!xlsxPath || !sheetName) {
        throw new Error("dump requires 2 arguments: <xlsx> <sheet>");
    }

    let workbook: WorkBook;
    try {
        workbook = readFile(xlsxPath);
    } catch (e) {
        throw new Error(`Failed to read ${xlsxPath}: ${e instanceof Error ? e.message : String(e)}`);
    }

    const sheet = workbook.Sheets[sheetName];

    if (!sheet) {
        throw new Error(`Sheet not found: ${sheetName}`);
    }

    const json = utils.sheet_to_json(sheet, {
        defval: "",
    });

    console.log(JSON.stringify(json, null, 2));
}