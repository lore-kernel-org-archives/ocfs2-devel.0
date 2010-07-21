From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Wed, 21 Jul 2010 10:42:51 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] JBD2: Allow feature checks before
	journal recovery
In-Reply-To: <20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
References: <871vbax86w.fsf@patl.com>
	<20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
Message-ID: <AANLkTikdCRfgDRLHZ7zr-ZALU8g8LwWc5We-CgbcQ8mF@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Jul 21, 2010 at 10:27 AM, Jan Kara <jack@suse.cz> wrote:
>> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index bc2ff59..c5a864f 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t *journal, unsigned long compat,
>>
>> ? ? ? if (!compat && !ro && !incompat)
>> ? ? ? ? ? ? ? return 1;
>> + ? ? if (journal_get_superblock(journal))
>> + ? ? ? ? ? ? return 0;
>> ? ? ? if (journal->j_format_version == 1)
>> ? ? ? ? ? ? ? return 0;
>
> This looks OK in principle. It would be even nicer to avoid all the checks
> journal_get_superblock() when the superblock is actually loaded so that we
> don't do them each time jbd2_journal_check_used_features is called...

How about this?

         if (!compat && !ro && !incompat)
                return 1;
+        if (journal->j_format_version == 0 &&
journal_get_superblock(journal) != 0)
+               return 0;
        if (journal->j_format_version == 1)
                return 0;

journal_init_common() uses kzalloc() to allocate the journal_t, and
journal_get_superblock() fills it in, so I believe this is a valid
test.

 - Pat
