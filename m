From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 12 Feb 2014 15:12:21 -0800
Subject: [Ocfs2-devel] [patch 04/11] ocfs2: fix a tiny race when	running
	dirop_fileop_racer
In-Reply-To: <52FA1A9F.5080702@huawei.com>
References: <20140124204703.AF70F5A4203@corp2gmr1-2.hot.corp.google.com>
	<20140205233106.GM24361@wotan.suse.de>
	<52FA1A9F.5080702@huawei.com>
Message-ID: <20140212231221.GY24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 11, 2014 at 08:42:07PM +0800, Xue jiufei wrote:
> > I am confused as to how this race happens.
> > 
> > Something like "ls /race/16' shouldn't hold locks on 'race' and '16' at the
> > same time. It should look more like:
> > 
> > <userspace does readdir /race/16>
> > PR race
> > <kernel looks up '16' in 'race'>
> > Unlock PR race
> > PR 16
> > <get dirents from '16'>
> > Unlock PR 16
> > <return dirents to userspace>
> > 
> > Can you please explain where I may be going wrong? Also an strace of the
> > locked up 'ls' as well as the output of sysrq-t when it's deadlocked would
> > help show what's going on.
> > 	--Mark
> > 
> when doing 'ls /race/16', it calls vfs_fstatat->..->d_alloc()->ocfs2_lookup()
> after readdir(). ocfs2_lookup() first get PR lock of race, and then get PR
> lock of 16 in ocfs2_iget() without unlocking PR race.

Ok I see how that can happen now, thanks! Another solution might be to
trylock in ocfs2_read_locked_inode() but I think this is a better approach
as we'll leave the potential impact in rename. I will give the patch another
look and send my review shortly, thanks!
	--Mark

--
Mark Fasheh
