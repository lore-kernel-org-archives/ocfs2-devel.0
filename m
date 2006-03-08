From: Adrian Bunk <bunk@stusta.de>
Date: Wed, 8 Mar 2006 12:30:52 +0100
Subject: [Ocfs2-devel] 2.6.16-rc5-mm3: Why did dlm_lockres_master_requery()
	become global?
In-Reply-To: <20060307021929.754329c9.akpm@osdl.org>
References: <20060307021929.754329c9.akpm@osdl.org>
Message-ID: <20060308113052.GF4006@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@osdl.org>, mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Mar 07, 2006 at 02:19:29AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.16-rc3-mm2:
>...
>  git-ocfs2.patch
>...
>  git trees
>...

Why did dlm_lockres_master_requery() become global?

It is neither used in another file nor does any of the changeset 
descriptions escribe it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
