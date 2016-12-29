From: Gang He <ghe@suse.com>
Date: Wed, 28 Dec 2016 19:54:18 -0700
Subject: [Ocfs2-devel] [PATCH v2 2/4] ocfs2: fix some small problems
In-Reply-To: <CAAXPY_LMr3a8D=YB0-My9gZqbGQBMN3sic3-1wnicRhnT8F+_g@mail.gmail.com>
References: <1482308461-12964-1-git-send-email-ghe@suse.com>
	<1482308461-12964-3-git-send-email-ghe@suse.com>
	<CAAXPY_LMr3a8D=YB0-My9gZqbGQBMN3sic3-1wnicRhnT8F+_g@mail.gmail.com>
Message-ID: <5864EB5A020000F90005CFF8@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com
Cc: jlbec@evilplan.org, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org




>>> 
> Hi Gang, one small comment below:
> 
> On Wed, Dec 21, 2016 at 2:20 AM, Gang He <ghe@suse.com> wrote:
>> First, move setting fe_done = 1 in spin lock, avoid bring
>> any potential race condition. Second, tune mlog message level
>> from ERROR to NOTICE, since the message should not belong to
>> error message.
>>
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>  fs/ocfs2/filecheck.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> @@ -545,11 +545,11 @@ static ssize_t ocfs2_filecheck_store(struct kobject 
> *kobj,
>>         spin_lock(&ent->fs_fcheck->fc_lock);
>>         if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
>>             (ent->fs_fcheck->fc_done == 0)) {
>> -               mlog(ML_ERROR,
>> +               mlog(ML_NOTICE,
>>                 "Cannot do more file check "
>>                 "since file check queue(%u) is full now\n",
>>                 ent->fs_fcheck->fc_max);
>> -               ret = -EBUSY;
>> +               ret = -EAGAIN;
> 
> This change wasn't described in the patch header. Granted, from the
> message above the change, -EAGAIN certainly seems a more reasonable
> return value but it would be good to know whether this was intended
> and why.
Hello Mark, thank for your comments, I will add the description for this change in V3.
Do you have any other comments for the other patches in v2?

Thanks
Gang

> 
> Thanks,
>    --Mark
