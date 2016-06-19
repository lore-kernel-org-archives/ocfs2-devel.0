From: Jan Kara <jack@suse.cz>
Date: Sun, 19 Jun 2016 18:20:21 +0200
Subject: [Ocfs2-devel] [PATCH] quota: use time64_t internally
In-Reply-To: <20160617200344.2096348-1-arnd@arndb.de>
References: <20160617200344.2096348-1-arnd@arndb.de>
Message-ID: <20160619162021.GA6882@quack2.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.com>, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Fri 17-06-16 22:03:16, Arnd Bergmann wrote:
> The quota subsystem has two formats, the old v1 format using architecture
> specific time_t values on the on-disk format, while the v2 format
> (introduced in Linux 2.5.16 and 2.4.22) uses fixed 64-bit little-endian.
> 
> While there is no future for the v1 format beyond y2038, the v2 format
> is almost there on 32-bit architectures, as both the user interface
> and the on-disk format use 64-bit timestamps, just not the time_t
> inbetween.
> 
> This changes the internal representation to use time64_t, which will
> end up doing the right thing everywhere for v2 format.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks. I've added the patch to my tree and will push it to Linus in the
next merge window.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
