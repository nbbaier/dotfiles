def onlyvalues: [ keys[] as $k | .[$k] ];
def to_csv($headers): ($headers | @csv), (.[] | [.[$headers[]]] | @csv);
