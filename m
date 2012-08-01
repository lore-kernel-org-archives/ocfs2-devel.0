From: Vincent ETIENNE <vetienne@aprogsys.com>
Date: Wed, 01 Aug 2012 22:43:20 +0200
Subject: [Ocfs2-devel] kernel BUG at fs/buffer.c:2886! Linux 3.5.0
In-Reply-To: <5016D2C0.6090708@vetienne.net>
References: <501313B6.70801@aprogsys.com>
	<20120730063000.GA4025@dhcp-172-17-9-228.mtv.corp.google.com>
	<50163B8A.7060509@aprogsys.com>
	<20120730075333.GC4025@dhcp-172-17-9-228.mtv.corp.google.com>
	<5016D2C0.6090708@vetienne.net>
Message-ID: <501994E8.9070100@aprogsys.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent ETIENNE <ve@vetienne.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@oss.oracle.com

Hi
Some further progress on bisection

I'm now here

git bisect start
# bad: [2d534926205db9ffce4bbbde67cb9b2cee4b835c] Merge tag
'irqdomain-for-linus' of git://git.secretlab.ca/git/linux-2.6
git bisect bad 2d534926205db9ffce4bbbde67cb9b2cee4b835c
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
git bisect good c3b92c8787367a8bb53d57d9789b558f1295cc96
# good: [95211279c5ad00a317c98221d7e4365e02f20836] Merge branch 'akpm'
(Andrew's patch-bomb)
git bisect good 95211279c5ad00a317c98221d7e4365e02f20836
# good: [654443e20dfc0617231f28a07c96a979ee1a0239] Merge branch
'perf-uprobes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 654443e20dfc0617231f28a07c96a979ee1a0239
# bad: [f0a08fcb5972167e55faa330c4a24fbaa3328b1f] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
git bisect bad f0a08fcb5972167e55faa330c4a24fbaa3328b1f
# bad: [f5e7e844a571124ffc117d4696787d6afc4fc5ae] Merge tag
'for-linus-3.5-20120601' of git://git.infradead.org/linux-mtd
git bisect bad f5e7e844a571124ffc117d4696787d6afc4fc5ae
# good: [f465d145d76803fe6332092775d891c8c509aa44] Merge tag
'cleanup-initcall' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good f465d145d76803fe6332092775d891c8c509aa44
# good: [a70f35af4e49f87ba4b6c4b30220fbb66cd74af6] Merge branch
'for-3.5/drivers' of git://git.kernel.dk/linux-block
git bisect good a70f35af4e49f87ba4b6c4b30220fbb66cd74af6
# good: [a00b6151a2ae4c52576c35d3998e144a993d50b8] Merge branch
'for-3.5-take-2' of git://linux-nfs.org/~bfields/linux
git bisect good a00b6151a2ae4c52576c35d3998e144a993d50b8
# bad: [1193755ac6328ad240ba987e6ec41d5e8baf0680] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad 1193755ac6328ad240ba987e6ec41d5e8baf0680
# good: [51eab603f5c86dd1eae4c525df3e7f7eeab401d6] Merge branch
'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good 51eab603f5c86dd1eae4c525df3e7f7eeab401d6
# bad: [eb36c5873b96e8c7376768d3906da74aae6e3839] new helper:
vm_mmap_pgoff()
git bisect bad eb36c5873b96e8c7376768d3906da74aae6e3839

but got a problem ( kernel does not compile ) at next iteration
need to dig into git bisect for how to select another entry

Vincent
