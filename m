From: Eric W. Biederman <ebiederm@xmission.com>
Date: Fri, 29 May 2020 07:46:49 -0500
Subject: [Ocfs2-devel] [PATCH 02/13] cdrom: use new sysctl subdir helper
	register_sysctl_subdir()
In-Reply-To: <20200529074108.16928-3-mcgrof@kernel.org> (Luis Chamberlain's
	message of "Fri, 29 May 2020 07:40:57 +0000")
References: <20200529074108.16928-1-mcgrof@kernel.org>
	<20200529074108.16928-3-mcgrof@kernel.org>
Message-ID: <871rn2ucw6.fsf@x220.int.ebiederm.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: jack@suse.cz, rafael@kernel.org, airlied@linux.ie, benh@kernel.crashing.org, amir73il@gmail.com, clemens@ladisch.de, dri-devel@lists.freedesktop.org, joseph.qi@linux.alibaba.com, sfr@canb.auug.org.au, mark@fasheh.com, rdna@fb.com, yzaikin@google.com, keescook@chromium.org, arnd@arndb.de, intel-gfx@lists.freedesktop.org, julia.lawall@lip6.fr, viro@zeniv.linux.org.uk, nixiaoming@huawei.com, vbabka@suse.cz, axboe@kernel.dk, tytso@mit.edu, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com, jlbec@evilplan.org

Luis Chamberlain <mcgrof@kernel.org> writes:

> This simplifies the code considerably. The following coccinelle

With register_sysctl the code would read:

	cdrom_sysctl_header = register_sysctl("dev/cdrom", cdrom_table);

Please go that direction.  Thank you.

Eric
