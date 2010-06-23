From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 23 Jun 2010 13:25:29 -0500
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <4C1B9968.6020805@oracle.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
	<4C1B9968.6020805@oracle.com>
Message-ID: <AANLkTilk1YjhLjRectGjzgTKpK4bBeQlKj1Y_9F110bx@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Sorry for the delay in responding. I was swamped with other high priority tasks.

On Fri, Jun 18, 2010 at 11:06 AM, Sunil Mushran
<sunil.mushran@oracle.com> wrote:
> Thanks for taking on this task.
>
> One overall comment about comments. Instead of sprinkling
> the same line everywhere, add the full description in one place.
> Maybe atop ocfs2_attach_dentry_gen(). Describe it fully. And then
> let the code speak for itself.
>
> Also, do remember to run the patch thru scripts/checkpatch.pl.
>

Yes, I understand. Will make sure from next time.


> On 06/18/2010 08:02 AM, Goldwyn Rodrigues wrote:
>>
>> Track negative dentries by recording the generation number of the parent
>> directory in d_fsdata. The generation number for the parent directory is
>> recorded in the inode_info, which increments every time the lock on the
>> directory is dropped.
>>
>> If the generation number of the parent directory and the negative dentry
>> matches, there is no need to perform the revalidate, else a revalidate
>> is forced. This improves performance in situations where nodes look for
>> the same non-existent file multiple times.
>>
>> Thanks Mark for explaining the DLM sequence.
>>
>> Signed-off-by: Goldwyn Rodrigues<rgoldwyn@suse.de>
>> ---
>> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
>> index b4957c7..f29095b 100644
>> --- a/fs/ocfs2/dcache.c
>> +++ b/fs/ocfs2/dcache.c
>> @@ -40,6 +40,16 @@
>> ?#include "inode.h"
>> ?#include "super.h"
>>
>> +void ocfs2_dentry_attach_gen(struct dentry *dentry)
>> +{
>> + ? ? ? int *gen = (int *)kmalloc(sizeof(int), GFP_KERNEL);
>> + ? ? ? *gen = OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
>> + ? ? ? /* Generation numbers are specifically for negative dentries */
>> + ? ? ? if (dentry->d_inode)
>> + ? ? ? ? ? ? ? BUG();
>> + ? ? ? dentry->d_fsdata = (void *)gen;
>> +}
>> +
>>
>
> kmalloc()s can fail. If this is just an int, why not just store it
> directly in d_fsdata. Add appropriate casts.

This will cause compilation warnings for either x86_64 or i686 systems
depending on the data type we choose. I will do this anyways.

>
> Also, are you sure about the locking when reading the parent's
> generation.
>

No, what lockings do you suspect might be required?


>> ?static int ocfs2_dentry_revalidate(struct dentry *dentry,
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? struct nameidata *nd)
>> @@ -51,10 +61,21 @@ static int ocfs2_dentry_revalidate(struct dentry
>> *dentry,
>> ? ? ? ?mlog_entry("(0x%p, '%.*s')\n", dentry,
>> ? ? ? ? ? ? ? ? ? dentry->d_name.len, dentry->d_name.name);
>>
>> - ? ? ? /* Never trust a negative dentry - force a new lookup. */
>> + ? ? ? /* For a negative dentry -
>> + ? ? ? ? ?check the generation number of the parent and compare with the
>> + ? ? ? ? ?one stored in the inode.
>> + ? ? ? ? ?*/
>> ? ? ? ?if (inode == NULL) {
>> - ? ? ? ? ? ? ? mlog(0, "negative dentry: %.*s\n", dentry->d_name.len,
>> - ? ? ? ? ? ? ? ? ? ?dentry->d_name.name);
>> + ? ? ? ? ? ? ? int *gen = (int *)dentry->d_fsdata;
>> + ? ? ? ? ? ? ? int parent_gen =
>> + ? ? ? ? ? ? ? ? ? ? ? OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
>> + ? ? ? ? ? ? ? mlog(0, "negative dentry: %.*s parent gen: %u dentry gen:
>> %u\n",
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? dentry->d_name.len, dentry->d_name.name,
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? parent_gen, *gen);
>> + ? ? ? ? ? ? ? if (*gen == parent_gen)
>> + ? ? ? ? ? ? ? ? ? ? ? ret = 1;
>> + ? ? ? ? ? ? ? else
>> + ? ? ? ? ? ? ? ? ? ? ? *gen = parent_gen;
>> ? ? ? ? ? ? ? ?goto bail;
>> ? ? ? ?}
>>
>
> Code is hard to read. See one possible rewrite below. This rewrite
> requires adding a "revalidated" label above ret = 1.
>
> + ? ? ? ? ? ? ? int *gen = (int *)dentry->d_fsdata;
> + ? ? ? ? ? ? ? int pgen =
> OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
> +
> + ? ? ? ? ? ? ? mlog(0, "negative dentry: %.*s parent gen: %u dentry gen:
> %u\n",
> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? dentry->d_name.len, dentry->d_name.name,
> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? parent_gen, *gen);
> +
> + ? ? ? ? ? ? ? if (*gen != pgen) {
> + ? ? ? ? ? ? ? ? ? ? ? *gen = pgen;
> + ? ? ? ? ? ? ? ? ? ? ? goto bail;
> + ? ? ? ? ? ? ? }
> +
> + ? ? ? ? ? ? ? goto revalidated;
> ? ? ? ?}
>

Ok, understood.

<snipped>

-- 
Goldwyn
