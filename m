From: Mark Fasheh <mfasheh@versity.com>
Date: Wed, 28 Dec 2016 16:34:08 -0600
Subject: [Ocfs2-devel] [PATCH v2 2/4] ocfs2: fix some small problems
In-Reply-To: <1482308461-12964-3-git-send-email-ghe@suse.com>
References: <1482308461-12964-1-git-send-email-ghe@suse.com>
	<1482308461-12964-3-git-send-email-ghe@suse.com>
Message-ID: <CAAXPY_LMr3a8D=YB0-My9gZqbGQBMN3sic3-1wnicRhnT8F+_g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>

Hi Gang, one small comment below:

On Wed, Dec 21, 2016 at 2:20 AM, Gang He <ghe@suse.com> wrote:
> First, move setting fe_done = 1 in spin lock, avoid bring
> any potential race condition. Second, tune mlog message level
> from ERROR to NOTICE, since the message should not belong to
> error message.
>
> Signed-off-by: Gang He <ghe@suse.com>
> ---
>  fs/ocfs2/filecheck.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> @@ -545,11 +545,11 @@ static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
>         spin_lock(&ent->fs_fcheck->fc_lock);
>         if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
>             (ent->fs_fcheck->fc_done == 0)) {
> -               mlog(ML_ERROR,
> +               mlog(ML_NOTICE,
>                 "Cannot do more file check "
>                 "since file check queue(%u) is full now\n",
>                 ent->fs_fcheck->fc_max);
> -               ret = -EBUSY;
> +               ret = -EAGAIN;

This change wasn't described in the patch header. Granted, from the
message above the change, -EAGAIN certainly seems a more reasonable
return value but it would be good to know whether this was intended
and why.

Thanks,
   --Mark
