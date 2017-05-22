From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 May 2017 14:20:55 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a static checker warning
In-Reply-To: <1495428877-7440-1-git-send-email-ghe@suse.com>
References: <1495428877-7440-1-git-send-email-ghe@suse.com>
Message-ID: <20170522142055.7ebf9fae4dbce0e3ddda806a@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: mfasheh@versity.com, jlbec@evilplan.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, 22 May 2017 12:54:37 +0800 Gang He <ghe@suse.com> wrote:

> This patch will fix a static checker warning, this warning was
> caused by commit d56a8f32e4c662509ce50a37e78fa66c777977d3. after
> apply this patch, the error return value will not be NULL(zero).

When identifying another commit, please use the form

d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")


And when fixing warnings such as this, please quote the warning in full
and identify which checker tool generated that warning.
