From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 13 Jun 2008 01:54:11 +0200
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
Message-ID: <20080612235410.GC4012@localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi,

I'm a bit confused by configfs module reference counting, and I feel
that it does not really protect against module unloading. If my feeling
is correct, I'd suggest to change module reference counting rules in
configfs, for instance like in the attached patch. If my feeling is
wrong, could someone shed some light?

Thanks

Louis

-- 
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/
-------------- next part --------------
A non-text attachment was scrubbed...
Name: configfs-fix-module-refcount.patch
Type: text/x-diff
Size: 6835 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080613/32facd75/attachment-0001.bin 
