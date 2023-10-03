class Clients {
    [string]$Username
    [string]$Password
}

class DNSrecord {
    [string]$host
    [ValidateSet("A", "AAAA", "AFSDB", "APL", "CAA", "CDNSKEY", "CDS", "CERT", "CNAME", "CSYNC", "DHCID", "DLV", "DNAME", "DNSKEY", "DS", "EUI48", "EUI64", "HINFO", "HIP", "HTTPS", "IPSECKEY", "KEY", "KX", "LOC", "MX", "NAPTR", "NS", "NSEC", "NSEC3", "NSEC3PARAM", "OPENPGPKEY", "PTR", "RRSIG", "RP", "SIG", "SMIMEA", "SOA", "SRV", "SSHFP", "SVCB", "TA", "TKEY", "TLSA", "TSIG", "TXT", "URI", "ZONEMD", "*", "AXFR", "IXFR", "OPT", "MD", "MF", "MB", "MG", "MR", "MINFO", "MAILB", "WKS", "NB", "NBSTAT", "NULL", "A6", "NXT", "SIG", "RP", "X25", "ISDN", "RT", "NSAP", "NSAP-PTR", "PX", "EID", "NIMLOC", "ATMA", "SINK", "GPOS", "UINFO", "UID", "GID", "UNSPEC", "SPF", "NINFO", "RKEY", "TALINK", "NID", "L32", "L64", "LP", "DOA")]
    [string]$RecordType

}