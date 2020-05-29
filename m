From: Kees Cook <keescook@chromium.org>
Date: Fri, 29 May 2020 07:49:15 -0700
Subject: [Ocfs2-devel] [Intel-gfx] [PATCH 06/13] ocfs2: use new sysctl
 subdir helper register_sysctl_subdir()
In-Reply-To: <20200529114912.GC11244@42.do-not-panic.com>
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-7-mcgrof@kernel.org>
	<202005290121.C78B4AC@keescook>
	<20200529114912.GC11244@42.do-not-panic.com>
Message-ID: <202005290748.043EFFA3F@keescook>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, jlbec@evilplan.org, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri, May 29, 2020 at 11:49:12AM +0000, Luis Chamberlain wrote:
> Yikes, sense, you're right. Nope, I left the random config tests to
> 0day. Will fix, thanks!

Yeah, I do the same for randconfig, but I always do an "allmodconfig"
build before sending stuff. It's a good smoke test.

-- 
Kees Cook
