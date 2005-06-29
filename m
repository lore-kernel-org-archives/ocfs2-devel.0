From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Jun 29 20:30:27 2005
Subject: [Ocfs2-devel] [-mm patch] CONFIGFS_FS: "If unsure, say N."
In-Reply-To: <20050630011015.GC27478@stusta.de>
References: <20050624080315.GC26545@stusta.de>
	<20050629213038.GA23823@ca-server1.us.oracle.com>
	<20050630004738.GA27478@stusta.de>
	<20050630005723.GE23823@ca-server1.us.oracle.com>
	<20050630011015.GC27478@stusta.de>
Message-ID: <20050630013011.GF23823@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Thu, Jun 30, 2005 at 03:10:15AM +0200, Adrian Bunk wrote:
> The question is:
> Assume a user doesn't use external modules, will enabling this option 
> have any effect for him except that it wastes some bytes of his RAM?
> 
> sysfs is useful in this case.
> How is configfs useful in this case?

	I'm not saying it is.  I'm saying that "Hey, if you are unsure
you want 'N'" is a good thing to say, but removing the description of
"what configfs is" is unhelpful and unneeded.

Joel

-- 

"And yet I fight,
 And yet I fight this battle all alone.
 No one to cry to;
 No place to call home."

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
