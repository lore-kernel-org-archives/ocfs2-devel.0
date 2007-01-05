From: Philipp Reisner <philipp.reisner@linbit.com>
Date: Fri Jan  5 06:07:33 2007
Subject: [Ocfs2-devel] Fixing cluster/heartbeat.c's use of bio_add_page()
Message-ID: <200701051506.52840.philipp.reisner@linbit.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi There,

As was already pointed out Mathieu Avila on Thu, 07 Sep 2006 03:15:25 -0700
that OCFS2 is expecting bio_add_page() to add pages to BIOs in an easily
predictable manner.

That is not true, especially for devices with own merge_bvec_fn().

Therefore OCFS2's heartbeat code is very likely to fail on such devices.

The attached patch corrects this, and reduces the file cluster/heartbeat.c
by 90 lines.

  The whole patch builds around the change that the bio_put() call is
  moved to the bio's bi_end_io() function.
  This makes the whole idea of trying to predict the behaviour of 
  bio_add_page() unnecessary, therefore we can remove compute_max_sectors()
  and o2hb_compute_request_limits().

-Phil

PS1: With that applied I can happily run OCFS2 on a DRBD-8.0 device which
     sits on top of software raid (both have interesting merge_bvec_fn()
     functions.

PS2: I created the ocfs2-fix-bio_add_page.diff on 2.6.17 .
     And later refitted the patch to 2.6.20-rc2.
-- 
: Dipl-Ing Philipp Reisner                      Tel +43-1-8178292-50 :
: LINBIT Information Technologies GmbH          Fax +43-1-8178292-82 :
: Vivenotgasse 48, 1120 Vienna, Austria        http://www.linbit.com :
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-fix-bio_add_page.diff
Type: text/x-diff
Size: 9363 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20070105/3ebcad56/ocfs2-fix-bio_add_page.bin
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-fix-bio_add_page-for-2.6.20-rc2.diff
Type: text/x-diff
Size: 8766 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20070105/3ebcad56/ocfs2-fix-bio_add_page-for-2.6.20-rc2.bin
