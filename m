From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Jul  1 04:38:05 2004
Subject: [Ocfs2-devel] 
	RE: [Patch] We resolve the throughput drop problem when reading
	files in OCFS2 volume in the patch "ocfs2-truncate-pages-1.patch"
	against svn 1226.
Message-ID: <3ACA40606221794F80A5670F0AF15F8404C7A389@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Seems the attach file is pending, so I resend the text.


________________________________

        From: Ling, Xiaofeng
        Sent: 2004=C4=EA7=D4=C21=C8=D5 10:58
        To: Zhang, Sonic; Ocfs2-Devel
        Cc: Fu, Michael; Rusty Lynch; Yang, Elton
        Subject: RE: [Patch] We resolve the throughput drop problem when =
reading files in OCFS2 volume in the patch =
"ocfs2-truncate-pages-1.patch" against svn 1226.
      =20
      =20
                The follow is the iozone data, more details and chart =
see the attached excel file.
       =20
        Patch
        =
-------------------------------------------------------------------------=
-------------
               =20
        Reader Report                                                    =
                                                     =20
                4        8       16      32      64      128     256     =
512     1024    2048    4096    8192    16384=20
        64       1598912         1777499         1943128         2071969 =
        2004067                                                          =
            =20
        128      1620842         1704341         1854338         1968802 =
        1968542         1561586                                          =
                    =20
        256      1524873         1694107         1789488         1855974 =
        1842561         1437728         839039                           =
                    =20
        512      1376544         1524077         1657088         1758991 =
        1706520         1394820         1016045         813973           =
                            =20
        1024     1420169         1578084         1656991         1721029 =
        1765775         1446558         1043858         787083  759072   =
                            =20
        2048     1339360         1445368         1558482         1589936 =
        1851715         1571751         997993  746340  735349  733286   =
                    =20
        4096     1385634         1463884         1618401         1969262 =
        1994058         1642284         821180  669402  717088  723936  =
723021               =20
        8192     1411918         1747808         1949966         1676303 =
        1938468         1615140         900523  715774  698377  701968  =
627841  710429       =20
        16384    1617231         1830201         1952354         2040357 =
        2038308         1605189         939821  724924  715080  664610  =
711204  710615  710219
        32768    0       0       0       0       2067522         1605956 =
        990810  721967  714989  712581  713324  711759  713559
        65536    0       0       0       0       2099229         1651818 =
        994749  727030  717902  712820  713294  714506  713139
        131072   0       0       0       0       2127068         1672133 =
        1004513         727894  715454  716397  715638  714982  717553
        262144   0       0       0       0       2038921         1603209 =
        973908  0                                            =20
       =20
        Orginal
        =
-------------------------------------------------------------------------=
-------------
       =20
                Reader Report                                            =
                                                     =20
                4        8       16      32      64      128     256     =
512     1024    2048    4096    8192 =20
        64       1418691         1601660         1687371         1829415 =
        1781618                                                          =
    =20
        128      25291   7172    8278    11356   6073    40417           =
                                     =20
        256      26296   16072   10638   10678   15114   13271   16182   =
                                     =20
        512      16252   16912   15518   9713    15167   24526   23911   =
10987                                =20
        1024     19316   15217   14983   16215   16808   16828   22846   =
11853   15447                        =20
        2048     16446   17539   17294   16403   20288   16839   16805   =
17899   18129   19984                =20
        4096     17530   18042   17835   17542   18716   17861   21439   =
17794   17879   18493   18979        =20
        8192     18186   18170   18910   18544   19125   19514   19070   =
18425   19327   17782   18586   19309=20
        16384    19698   20661   20165   20156   19664   19736   18994   =
19272   18764   19496   20083   20630=20
        32768    0       0       0       0       20787   19905   19813   =
20165   20052   20330   19982   19555=20
        65536    0       0       0       0       20619   19989   19695   =
19608   20025   20014   19957   19826=20
        131072   0       0       0       0       20677   20611   19350   =
19878   19810   19848   20011   19825=20
        262144   0       0       0       0       20340   20069   19602   =
19851   19738   19694   19705   19624=20
        524288   0       0       0       0       19954   19836   19238   =
0                                    =20
               =20
       =20
       =20


        >-----Original Message-----
        >From: Zhang, Sonic
        >Sent: 2004=C4=EA7=D4=C21=C8=D5 10:39
        >To: Ocfs2-Devel
        >Cc: Ling, Xiaofeng; Fu, Michael; Rusty Lynch; Yang, Elton; =
Zhang, Sonic
        >Subject: [Patch] We resolve the throughput drop problem when
        >reading files in OCFS2 volume in the patch
        >"ocfs2-truncate-pages-1.patch" against svn 1226.
        >
        >Hi,
        >
        >       We root caused the problem "The truncate_inode_page
        >call in ocfs_file_releasecauses the severethroughput drop of
        >file reading in OCFS2", which we put forward in our former
        >mails. And now, we also generate a patch to resolve this
        >problem after one week debugging.
        >
        >       This patch is against OCFS2 svn 1226.
        >
        >       The average file reading throughput without our patch
        >is 16 Mbtye/sec.
        >       The average file reading throughput with our patch is
        >1600 Mbtye/sec.
        >       Our patch has 100 times improvement on file reading
        >throughput. We will submit the full benchmark data of izone in
        >the other mail soon.
        >
        >       In our patch, we remove ocfs_truncate_pages() and
        >ocfs_extent_map_destroy() from routine ocfs_file_open() and
        >ocfs_file_release(), which enable file data page reuse between
        >different and sequential file access in one node.
        >
        >       In current OCFS2 design, file data consistency among
        >all nodes in the cluster is only ensured if this file is
        >accessed in sequence. Our patch keeps the same consistency
        >level by a new vote request FLAG_TRUNCATE_PAGES and a new vote
        >action TRUNCATE_PAGES. This request is broadcast when a file
        >is asked to be opened for write. Then the receivers truncate
        >all in memory pages and extent maps of this file. The sender
        >truncates part of the pages and maps only when the file is
        >truncated (shortened).
        >
        >       Please refer to the attachment.
        >
        >       The throughput drop problem also occurs when creating,
        >changing and deleting directories on OCFS2 volume. But it is
        >not covered in this patch. We will work on the other patch to
        >solve this problem.
        >
        >       Any comments are appreciated.
        >       Thank you.
        >
        >
        >
        >*********************************************
        >Sonic Zhang
        >Software Engineer
        >Intel China Software Lab
        >Tel: (086)021-52574545-1667
        >iNet: 752-1667
        >*********************************************
        >
