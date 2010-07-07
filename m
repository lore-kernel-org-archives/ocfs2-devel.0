From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Tue, 6 Jul 2010 17:13:27 -0700
Subject: [Ocfs2-devel] [PATCH] OCFS2: Allow huge (> 16 TiB) volumes to
	mount
In-Reply-To: <20100706200438.GF17961@mail.oracle.com>
References: <87mxud74tw.fsf@gmail.com> <20100706200438.GF17961@mail.oracle.com>
Message-ID: <AANLkTilgO6V0ugvm3vvI5sHNC3zNxYa1zu_VxjCSoVIg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org

On Tue, Jul 6, 2010 at 1:04 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
>
> Thus, I propose the following jbd2 patch. ?jbd2 people, what do you
> think:
>
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index bc2ff59..7922d87 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t
> *journal,
>
> ? ? ? ?if (!compat && !ro && !incompat)
> ? ? ? ? ? ? ? ?return 1;
> + ? ? ? if (journal_get_superblock(journal))
> + ? ? ? ? ? ? ? return 0
> ? ? ? ?if (journal->j_format_version == 1)
> ? ? ? ? ? ? ? ?return 0;

As an alternative, could jbd2_journal_init_inode() just call
journal_get_superblock() itself?  That would naturally make the
feature bits valid as soon as the journal is initialized.  It would
also preserve all error checking, instead of converting superblock
read errors into "this journal has no features".

JBD2 developers, please advise.  OCFS2 needs to examine JBD2 journal
feature bits *before* the journal is recovered, which is not possible
at present.  What is the best approach to fixing this?

Thanks.

 - Pat
