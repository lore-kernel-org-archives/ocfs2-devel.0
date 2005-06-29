From: Adrian Bunk <bunk@stusta.de>
Date: Wed Jun 29 20:10:13 2005
Subject: [Ocfs2-devel] [-mm patch] CONFIGFS_FS: "If unsure, say N."
In-Reply-To: <20050630005723.GE23823@ca-server1.us.oracle.com>
References: <20050624080315.GC26545@stusta.de>
	<20050629213038.GA23823@ca-server1.us.oracle.com>
	<20050630004738.GA27478@stusta.de>
	<20050630005723.GE23823@ca-server1.us.oracle.com>
Message-ID: <20050630011015.GC27478@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, Jun 29, 2005 at 05:57:23PM -0700, Joel Becker wrote:
> On Thu, Jun 30, 2005 at 02:47:38AM +0200, Adrian Bunk wrote:
> > But I get your point, what about the patch below?
> 
> 	Non-descriptive.  We are descriptive for sysfs (and even allow
> the choice!).  I'd say that leaving the description but perhaps adding
> the caveat about modules and unsure-N might be a good way to go.

The question is:
Assume a user doesn't use external modules, will enabling this option 
have any effect for him except that it wastes some bytes of his RAM?

sysfs is useful in this case.
How is configfs useful in this case?

> Joel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
