From: jeff.liu <jeff.liu@oracle.com>
Date: Fri, 05 Mar 2010 16:21:44 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] du-enhancement: show the shared
 extents per file and the footprint v2
In-Reply-To: <4B90BE06.5030806@oracle.com>
References: <> <1267198108-7459-1-git-send-email-jeff.liu@oracle.com>
	<1267198108-7459-2-git-send-email-jeff.liu@oracle.com>
	<1267198108-7459-3-git-send-email-jeff.liu@oracle.com>
	<4BB44D82.7000403@oracle.com> <4B90B9D0.9030308@oracle.com>
	<4B90BE06.5030806@oracle.com>
Message-ID: <4B90BF18.3080406@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> Hi jeff,
> 
> jeff.liu wrote:
>> Hi Tao,
>>
>> Thanks for your comments.
>>
>> Tao Ma wrote:
>>> Jie Liu wrote:
>>>> this patch add fiemap feature support in du, du show the shared
>>>> extents size in parens per file
>>>> as well as the footprint for each request with either '--shared-size'
>>>> or '-E' option.
>>>>
>>>> the footprint which is total minus the sum total of all extents in the
>>>> rbtree
>>>> that have ei_shared_count > 0.
>>>>
>>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>>> ---
>>>>  coreutils-6.9/src/du.c |  444
>>>> +++++++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 files changed, 437 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/coreutils-6.9/src/du.c b/coreutils-6.9/src/du.c
>>>> index 206d318..3adc3a8 100644
>>>> --- a/coreutils-6.9/src/du.c
>>>> +++ b/coreutils-6.9/src/du.c
>>>> +/* Insert new extent based on the new parent.  */
>>>> +
>>>> +static void
>>>> +insert_new_extent_info (struct rb_node *parent,
>>>> +                        uint64_t fe_physical,
>>>> +                        uint64_t fe_length,
>>>> +                        size_t extent_shared_count)
>>>> +{
>>>> +  struct rb_node **p = parent ? &parent : &((&fe_root)->rb_node);
>>>> +  struct rb_node *pp = NULL;
>>>> +  struct extent_info *this = NULL;
>>>> +  struct extent_info *ei;
>>>> +
>>>> +  while (*p)
>>>> +    {
>>>> +      pp = *p;
>>>> +      this = rb_entry (*p, struct extent_info, ei_node);
>>>> +
>>>> +      if (this->ei_physical > fe_physical)
>>>> +        p = &(*p)->rb_left;
>>>> +      else if (this->ei_physical < fe_physical)
>>>> +    p = &(*p)->rb_right;
>>>> +      else
>>>> +    return;
>>>>   
>>> I am just curious in your code the last "else" should never happen? If
>>> yes, maybe if we meet with this, it means a bug in the code.
>>> So better assert here?
>> IMHO, the last 'else' should not happen if the split algorithm works
>> correctly.
>> The current algorithm is designed to make sure there is no extent
>> overlap occurrs in the rbtree.
>> So I am prefer to abort the DU process by asserting there.
> as you said, it is *designed* to work well, but you can't say it works
> well. With a "assert", you know there is a problem. Without assert, you
> may cheated by the codes. ;) btw, you can have a look in ocfs2-tools.
> there are some codes like it with "assert".
Sorry, it looks my last comments didn't mentioned clearly, I means I agree with your point, it
should be asserted here.

>>>> +    /* If 0 extents are returned, then more ioctls
>>>> +       are not needed.  */
>>>> +    if (fiemap->fm_mapped_extents == 0)
>>>> +      goto close_file;
>>>> +
>>>> +    uint64_t ext_phy_offset;
>>>> +    uint64_t ext_len;
>>>> +    size_t i;
>>>>   
>>> better move these declaration above.
>> Do you means this is a bad coding style?
>>
>> Due to these variables resides function exceeds 1 screen page, so I
>> declares them here to
>> facilitate the variables reference like type and name. or else,
>> someone have to page up to refer to
>> them.
>> I'd like to keep the ext_phy_offset and ext_len in the bottom FOR
>> logical, but move 'i' to the
>> head of this function since it is well-known as an iterate counter.
>>
>> How do you think about that?
>> I just want to make the code looks more professional.
>>
>>>> +    for (i = 0; i < fiemap->fm_mapped_extents; i++)
>>>> +      {
>>             uint64_t ext_phy_offset;
>>             uint64_t ext_len;
> yeah, this looks better and you can combine the 4 lines into 2 actually. ;)
sure. :)
>         uint64_t ext_phy_offset = fm_ext[i].fe_physical;
>         uint64_t ext_len = fm_ext[i].fe_length;
>>>> +        ext_phy_offset = fm_ext[i].fe_physical;
>>>> +    ext_len = fm_ext[i].fe_length;
> 
> Regards,
> Tao

Thanks,
-Jeff
