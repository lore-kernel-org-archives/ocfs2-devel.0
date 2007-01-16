From: Philipp Reisner <philipp.reisner@linbit.com>
Date: Tue Jan 16 12:20:20 2007
Subject: [Ocfs2-devel] Fixing cluster/heartbeat.c's use of bio_add_page()
In-Reply-To: <20070116195757.GA6831@ca-server1.us.oracle.com>
References: <200701051506.52840.philipp.reisner@linbit.com>
	<200701111058.11212.philipp.reisner@linbit.com>
	<20070116195757.GA6831@ca-server1.us.oracle.com>
Message-ID: <200701162120.00829.philipp.reisner@linbit.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Am Dienstag, 16. Januar 2007 20:57 schrieb Mark Fasheh:
> On Thu, Jan 11, 2007 at 10:58:10AM +0100, Philipp Reisner wrote:
> > My try of a 'The perfect patch':
> >
> > Moved the bio_put() call into the bio's bi_end_io() function. This makes
> > the whole idea of trying to predict the behaviour of bio_add_page()
> > unnecessary. Removed compute_max_sectors() and
> > o2hb_compute_request_limits().
>
> Ok, this is uploading to ocfs2.git right now. It needs some testing in -mm
> (and internally) for a while before I push it upstream. Have you tried this
> in a cluster of more than one node?
>

Yes in my 2 node cluster. Running OCFS2 on top of DRBD8.

Here is an excerpt from one of the machines kernel log:

Jan 16 21:10:26 wurzel kernel: [15760.632055] drbd5: role( Secondary -> Primary )
Jan 16 21:10:26 wurzel kernel: [15760.632079] drbd5: Writing meta data super block now.
Jan 16 21:10:29 wurzel kernel: [15764.170075] drbd5: peer( Secondary -> Primary )
Jan 16 21:10:53 wurzel kernel: [15787.729397] OCFS2 1.3.3
Jan 16 21:11:08 wurzel kernel: [15802.715225] ocfs2_dlm: Nodes in domain ("B0E1160C780B4AA2A5E763036EE3910E"): 0
Jan 16 21:11:08 wurzel kernel: [15802.734416] JBD: Ignoring recovery information on journal
Jan 16 21:11:08 wurzel kernel: [15802.748171] kjournald starting.  Commit interval 5 seconds
Jan 16 21:11:08 wurzel kernel: [15802.749319] ocfs2: Mounting device (147,5) on (node 0, slot 0) with ordered data mode.
Jan 16 21:11:16 wurzel kernel: [15810.429171] o2net: accepted connection from node sepp (num 1) at 192.168.243.2:7777
Jan 16 21:11:20 wurzel kernel: [15814.585687] ocfs2_dlm: Node 1 joins domain B0E1160C780B4AA2A5E763036EE3910E
Jan 16 21:11:20 wurzel kernel: [15814.585692] ocfs2_dlm: Nodes in domain ("B0E1160C780B4AA2A5E763036EE3910E"): 0 1

-phil
-- 
: Dipl-Ing Philipp Reisner                      Tel +43-1-8178292-50 :
: LINBIT Information Technologies GmbH          Fax +43-1-8178292-82 :
: Vivenotgasse 48, 1120 Vienna, Austria        http://www.linbit.com :
