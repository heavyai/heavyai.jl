namespace java com.mapd.thrift.calciteserver

enum TCompletionHintType {
  COLUMN,
  TABLE,
  VIEW,
  SCHEMA,
  CATALOG,
  REPOSITORY,
  FUNCTION,
  KEYWORD
}

struct TCompletionHint {
  1: TCompletionHintType type;
  2: list<string> hints;
  3: string replaced;
}
