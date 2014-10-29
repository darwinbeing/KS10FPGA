//
// These are the test addresses for MAINDEC-10-DSKEA
//

begin
   case (PC[18:35])
     18'o000000: test = "DSKEA INIT";
     18'o030010: test = "DSKEA BEGIN1";
     18'o030637: test = "DSKEA STARTA";
     18'o030652: test = "DSKEA EBRCK0";
     18'o030663: test = "DSKEA EBRCK1";
     18'o030707: test = "DSKEA EBRCK2";
     18'o031024: test = "DSKEA EBRCK3";
     18'o031035: test = "DSKEA EBRCK4";
     18'o031153: test = "DSKEA UBRCK0";
     18'o031166: test = "DSKEA UBRCK1";
     18'o031201: test = "DSKEA UBRCK2";
     18'o031344: test = "DSKEA UBRCK3";
     18'o031521: test = "DSKEA P0TRP";
     18'o031521: test = "DSKEA P0PDLX";
     18'o031577: test = "DSKEA P0AROX";
     18'o031615: test = "DSKEA PDT0";
     18'o031636: test = "DSKEA PDT4A";
     18'o031660: test = "DSKEA PDT7";
     18'o031700: test = "DSKEA PDT10";
     18'o031716: test = "DSKEA ASHTST";
     18'o031734: test = "DSKEA ASHCTST";
     18'o031753: test = "DSKEA MULTST";
     18'o031771: test = "DSKEA IMULTST";
     18'o032007: test = "DSKEA ADJTST";
     18'o032022: test = "DSKEA FSCTST";
     18'o032035: test = "DSKEA FIXTST";
     18'o032053: test = "DSKEA FIXRTST";
     18'o032071: test = "DSKEA FADTST";
     18'o032104: test = "DSKEA DFADTST";
     18'o032117: test = "DSKEA FSBTST";
     18'o032133: test = "DSKEA DFSBTST";
     18'o032150: test = "DSKEA FMPTST";
     18'o032163: test = "DSKEA DFMPTST";
     18'o032176: test = "DSKEA DIVTST";
     18'o032217: test = "DSKEA IDIVTST";
     18'o032240: test = "DSKEA FDVTST";
     18'o032261: test = "DSKEA FDVRTST";
     18'o032302: test = "DSKEA DFDVTST";
     18'o032371: test = "DSKEA MAPCK0";
     18'o032401: test = "DSKEA MAPCK1";
     18'o032406: test = "DSKEA MAPCK2";
     18'o032413: test = "DSKEA MAPCK3";
     18'o032420: test = "DSKEA MAPCK4";
     18'o032425: test = "DSKEA MAPCK5";
     18'o032434: test = "DSKEA MAPCK6";
     18'o032444: test = "DSKEA PFAIL0";
     18'o032467: test = "DSKEA PFAIL1";
     18'o032504: test = "DSKEA PFAIL2";
     18'o032507: test = "DSKEA PFAIL3";
     18'o032522: test = "DSKEA PFAIL4";
     18'o032542: test = "DSKEA PFAIL6";
     18'o032547: test = "DSKEA EPPM0";
     18'o032557: test = "DSKEA EPPM1";
     18'o032564: test = "DSKEA EPPM2";
     18'o032571: test = "DSKEA EPPM3";
     18'o032600: test = "DSKEA EPPM4";
     18'o032607: test = "DSKEA EPPM5";
     18'o032613: test = "DSKEA EPPM6";
     18'o032622: test = "DSKEA EPPM7";
     18'o032632: test = "DSKEA AMTST4";
     18'o032714: test = "DSKEA AMTST7";
     18'o032764: test = "DSKEA PAGRDA";
     18'o032776: test = "DSKEA PAGRDB";
     18'o033005: test = "DSKEA PAGRDC";
     18'o033016: test = "DSKEA PAGRD0";
     18'o033122: test = "DSKEA PGWRTA";
     18'o033134: test = "DSKEA PGWTBB";
   endcase
end
