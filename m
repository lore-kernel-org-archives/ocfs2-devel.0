From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Jun 29 19:57:39 2005
Subject: [Ocfs2-devel] [-mm patch] CONFIGFS_FS: "If unsure, say N."
In-Reply-To: <20050630004738.GA27478@stusta.de>
References: <20050624080315.GC26545@stusta.de>
	<20050629213038.GA23823@ca-server1.us.oracle.com>
	<20050630004738.GA27478@stusta.de>
Message-ID: <20050630005723.GE23823@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Thu, Jun 30, 2005 at 02:47:38AM +0200, Adrian Bunk wrote:
> But I get your point, what about the patch below?

	Non-descriptive.  We are descriptive for sysfs (and even allow
the choice!).  I'd say that leaving the description but perhaps adding
the caveat about modules and unsure-N might be a good way to go.

Joel

-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
