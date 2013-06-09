From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 09 Jun 2013 12:10:47 -0000
Subject: [Ocfs2-devel] [PATCH] xattr: Constify ->name member of "struct
	xattr".
In-Reply-To: <20130609090721.GD5531@localhost>
References: <201305292152.CCF10933.FQJHFLOtOFVMSO@I-love.SAKURA.ne.jp>
	<201306082154.BDJ95357.MFQFVOJLSOtHFO@I-love.SAKURA.ne.jp>
	<20130609090721.GD5531@localhost>
Message-ID: <201306092109.GBB81777.JOHtFOMQVLSFOF@I-love.SAKURA.ne.jp>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jlbec@evilplan.org
Cc: ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, eparis@parisplace.org, casey@schaufler-ca.com, zohar@us.ibm.com, serge.hallyn@canonical.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org

Joel Becker wrote:
> I can't really comment on the concept, but if security folks agree, the
> ocfs2 part looks fine.

This is merely a bugfix/cleanup with a bit of cpu usage reduction.

I noticed that EVM by error returns "struct xattr"->name == NULL and
"struct xattr"->value != NULL if kstrdup(XATTR_EVM_SUFFIX, GFP_NOFS) failed,
resulting in EVM security attribute not associated with inode and leak memory.
The proposed (but now turned out to be incorrect) fix is
http://marc.info/?l=linux-security-module&m=136965357007829&w=2 .

But I also noticed that all of SELinux, Smack and EVM sets "struct xattr"->name
a kstrdup()ed constant suffix. Therefore, if passing constant suffix
("const char *") rather than kstrdup()ed constant suffix ("char *") does not
break "struct xattr"->name users, SELinux, Smack and EVM can omit kstrdup()ing
their constant suffix. Therefore, I'm querying you whether changing from
"char *name" to "const char *name" breaks your filesystem.

If my proposal breaks your filesystem, I'm happy to fix only EVM code.

Regards.
