From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Mar 18 00:14:34 2005
Subject: [Ocfs2-devel] New cluster initialization ABI
Message-ID: <20050318061435.GL2714@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Folks,
	The tiny clustering software that OCFS2 uses these days, O2CB,
has had a userspace<->kernel change.  The new interface uses usysfs
instead of ioctl(2).
	You will need revision 2006 of ocfs2 and revision 668 of
ocfs2-tools.  The two revisions go together.  Starting the clustering
software with /etc/init.d/o2cb works just as before.

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
