From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan 16 11:58:01 2007
Subject: [Ocfs2-devel] Fixing cluster/heartbeat.c's use of bio_add_page()
In-Reply-To: <200701111058.11212.philipp.reisner@linbit.com>
References: <200701051506.52840.philipp.reisner@linbit.com>
	<20070109222804.GY6831@ca-server1.us.oracle.com>
	<200701111058.11212.philipp.reisner@linbit.com>
Message-ID: <20070116195757.GA6831@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 11, 2007 at 10:58:10AM +0100, Philipp Reisner wrote:
> My try of a 'The perfect patch':
> 
> Moved the bio_put() call into the bio's bi_end_io() function. This makes the
> whole idea of trying to predict the behaviour of bio_add_page() unnecessary.
> Removed compute_max_sectors() and o2hb_compute_request_limits().

Ok, this is uploading to ocfs2.git right now. It needs some testing in -mm
(and internally) for a while before I push it upstream. Have you tried this
in a cluster of more than one node?

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
