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

import { readFile, utils, writeFile } from "npm:xlsx";

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

function openWorkbook(path: string) {
    try {
        return readFile(path);
    } catch {
        return utils.book_new();
    }
}

function getOrCreateSheet(workbook: any, sheetName: string) {
    let sheet = workbook.Sheets[sheetName];

    if (!sheet) {
        sheet = utils.aoa_to_sheet([]);
        utils.book_append_sheet(workbook, sheet, sheetName);
    }

    return sheet;
}

function updateRange(sheet: any, cell: string) {
    if (!sheet["!ref"]) {
        sheet["!ref"] = `${cell}:${cell}`;
        return;
    }

    const range = utils.decode_range(sheet["!ref"]);
    const target = utils.decode_cell(cell);

    range.s.r = Math.min(range.s.r, target.r);
    range.s.c = Math.min(range.s.c, target.c);

    range.e.r = Math.max(range.e.r, target.r);
    range.e.c = Math.max(range.e.c, target.c);

    sheet["!ref"] = utils.encode_range(range);
}

async function writeCsv() {
    const xlsxPath = args[1];
    const sheetName = args[2];
    const csvPath = args[3];

    if (!xlsxPath || !sheetName || !csvPath) {
        throw new Error("invalid args");
    }

    const workbook = openWorkbook(xlsxPath);

    const sheet = getOrCreateSheet(workbook, sheetName);

    const csv = await Deno.readTextFile(csvPath);

    const lines = csv
        .split(/\r?\n/)
        .map(v => v.trim())
        .filter(Boolean);

    for (const line of lines) {
        const cols = line.split(",");

        const cell = cols[0];
        const rawValue = cols[1];
        const type = cols[2] ?? "string";

        if (!cell || rawValue === undefined) {
            continue;
        }

        let value: any = rawValue;
        let cellType = "s";

        switch (type) {
            case "number":
                value = Number(rawValue);
                cellType = "n";
                break;

            case "boolean":
                value = rawValue === "true";
                cellType = "b";
                break;

            default:
                value = rawValue;
                cellType = "s";
                break;
        }

        sheet[cell] = {
            t: cellType,
            v: value,
        };

        updateRange(sheet, cell);
    }

    writeFile(workbook, xlsxPath);

    console.log(`updated: ${xlsxPath}`);
}

function readCell() {
    const xlsxPath = args[1];
    const sheetName = args[2];
    const cell = args[3];

    if (!xlsxPath || !sheetName || !cell) {
        throw new Error("invalid args");
    }

    const workbook = readFile(xlsxPath);

    const sheet = workbook.Sheets[sheetName];

    if (!sheet) {
        throw new Error(`sheet not found: ${sheetName}`);
    }

    console.log(sheet[cell]?.v ?? "");
}

function dumpSheet() {
    const xlsxPath = args[1];
    const sheetName = args[2];

    if (!xlsxPath || !sheetName) {
        throw new Error("invalid args");
    }

    const workbook = readFile(xlsxPath);

    const sheet = workbook.Sheets[sheetName];

    if (!sheet) {
        throw new Error(`sheet not found: ${sheetName}`);
    }

    const json = utils.sheet_to_json(sheet, {
        defval: "",
    });

    console.log(JSON.stringify(json, null, 2));
}