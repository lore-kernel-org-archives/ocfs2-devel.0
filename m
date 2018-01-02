From: alex chen <alex.chen@huawei.com>
Date: Tue, 2 Jan 2018 19:14:04 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs: fix
	fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix
In-Reply-To: <20180102103520.865665-1-arnd@arndb.de>
References: <20180102103520.865665-1-arnd@arndb.de>
Message-ID: <5A4B697C.4000000@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Changwei Ge <ge.changwei@h3c.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Jun Piao <piaojun@huawei.com>, Fabian Frederick <fabf@skynet.be>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Arnd,

On 2018/1/2 18:34, Arnd Bergmann wrote:
> Fixes: mmotm ("ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix")
I think this patch is not fit for mainline and will not be apply to mainline in the future.
Andrew can remove it from mm-tree.

Thanks,
Alex
