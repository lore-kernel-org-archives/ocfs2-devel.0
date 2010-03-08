From: jeff.liu <jeff.liu@oracle.com>
Date: Mon, 08 Mar 2010 23:30:05 +0800
Subject: [Ocfs2-devel] du_enhancement v3
Message-ID: <4B9517FD.10307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

The following is the v3 patchset for du enhancement.

The bugs fixed according to Tao's comments.

For now, I faced with another problem need your guys help confirm:
I skipped the inline file processing which its data mixed with metadata.
IMHO, it has pretty minor effect for the precise measurement of footprint, as a result,
the rebree process overhead is unworthy for inline file.

Any thoughts or suggestions for this case?


I run a few simple testing, it works:

>>> 1542 - 1 - 21 - 99 - 512 - 105 - 5
799
jeff at jeff-laptop:/shared-du  -E -m -c /ocfs2/*
0	/ocfs2/lost+found
1	/ocfs2/reflink
1	(1)	/ocfs2/test1
1	(1)	/ocfs2/test1r
21	(21)	/ocfs2/test2
21	(21)	/ocfs2/test2r
99	(99)	/ocfs2/test3
99	(99)	/ocfs2/test3r
40	/ocfs2/test4
22	(22)	/ocfs2/test4r
512	(512)	/ocfs2/test5
512	(512)	/ocfs2/test5r
105	(105)	/ocfs2/test6
105	(105)	/ocfs2/test6r
0	/ocfs2/test7
0	/ocfs2/test7r
5	(5)	/ocfs2/test8
0	(5)	/ocfs2/test8r
1542	total
799	footprint

>>> 1578232 - 5120 - 107520 - 524288 - 101376 - 1024 - 21504
817400
jeff at jeff-laptop:./shared-du  -E -k -c /ocfs2/*
0	/ocfs2/lost+found
88	/ocfs2/reflink
1024	(1024)	/ocfs2/test1
1024	(1024)	/ocfs2/test1r
21504	(21504)	/ocfs2/test2
21504	(21504)	/ocfs2/test2r
101376	(101376)	/ocfs2/test3
101376	(101376)	/ocfs2/test3r
40092	/ocfs2/test4
21508	(21508)	/ocfs2/test4r
524288	(524288)	/ocfs2/test5
524288	(524288)	/ocfs2/test5r
107520	(107520)	/ocfs2/test6
107520	(107520)	/ocfs2/test6r
0	/ocfs2/test7
0	/ocfs2/test7r
5120	(5120)	/ocfs2/test8
0	(5120)	/ocfs2/test8r
1578232	total
817400	footprint

>>> 1621360142 - 5242880 - 110100480 - 536870912 - 103809024 - 22020096 - 1048576
842268174
jeff at jeff-laptop:./shared-du  -E -b -c /ocfs2/*
3896	/ocfs2/bind_mount
3896	/ocfs2/lost+found
86414	/ocfs2/reflink
1048576	(1048576)	/ocfs2/test1
1048576	(1048576)	/ocfs2/test1r
22020096	(22020096)	/ocfs2/test2
22020096	(22020096)	/ocfs2/test2r
103809024	(103809024)	/ocfs2/test3
103809024	(103809024)	/ocfs2/test3r
41054208	/ocfs2/test4
22024192	(22024192)	/ocfs2/test4r
536870912	(536870912)	/ocfs2/test5
536870912	(536870912)	/ocfs2/test5r
110100480	(110100480)	/ocfs2/test6
110100480	(110100480)	/ocfs2/test6r
1800	/ocfs2/test7                             <<< inline file
1800	/ocfs2/test7r
5242880	(5242880)	/ocfs2/test8
5242880	(5242880)	/ocfs2/test8r
1621360142	total
842268174	footprint



Please review, any comments are appreciated!

Thanks,
-Jeff
