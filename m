From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue Mar  2 12:25:43 2004
Subject: [Ocfs2-devel] unknown symbol mark_buffer_clean found when compile
	OCFSv2 under kernel 2.6.0
In-Reply-To: <20040302180950.GA27202@penguin.co.intel.com>
References: 
	<37FBBA5F3A361C41AB7CE44558C3448E5A30D1@PDSMSX403.ccr.corp.intel.com>
	<20040302174322.GQ31527@ca-server1.us.oracle.com>
	<20040302175407.GA30145@ca-server1.us.oracle.com>
	<20040302180950.GA27202@penguin.co.intel.com>
Message-ID: <20040302182538.GS31527@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2004 at 10:09:50AM -0800, Rusty Lynch wrote:
> Which brings up an observation... the ocfs RPM spec file could configure
> the users /etc/modules.conf|/etc/modprobe.conf and remove the need for
> /etc/ocfs.conf.

	Red Hat does not provide a simple modules.conf/modprobe.conf
configuration system (ala modules.conf.d on Debian), so scripting this
is perilous at best.  It was determined that users would be very averse
to handling problems with this.  On the other hand, OCFSTool and
ocfs_uid_gen can munge ocfs.conf at will.

Joel

-- 

Life's Little Instruction Book #109

	"Know how to drive a stick shift."

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
