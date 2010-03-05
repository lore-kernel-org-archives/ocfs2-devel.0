From: jeff.liu <jeff.liu@oracle.com>
Date: Fri, 05 Mar 2010 15:59:12 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] du-enhancement: show the shared
 extents per file and the footprint v2
In-Reply-To: <4BB44D82.7000403@oracle.com>
References: <> <1267198108-7459-1-git-send-email-jeff.liu@oracle.com>
	<1267198108-7459-2-git-send-email-jeff.liu@oracle.com>
	<1267198108-7459-3-git-send-email-jeff.liu@oracle.com>
	<4BB44D82.7000403@oracle.com>
Message-ID: <4B90B9D0.9030308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tao,

Thanks for your comments.

Tao Ma wrote:
> Jie Liu wrote:
>> this patch add fiemap feature support in du, du show the shared
>> extents size in parens per file
>> as well as the footprint for each request with either '--shared-size'
>> or '-E' option.
>>
>> the footprint which is total minus the sum total of all extents in the
>> rbtree
>> that have ei_shared_count > 0.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  coreutils-6.9/src/du.c |  444
>> +++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 437 insertions(+), 7 deletions(-)
>>
>> diff --git a/coreutils-6.9/src/du.c b/coreutils-6.9/src/du.c
>> index 206d318..3adc3a8 100644
>> --- a/coreutils-6.9/src/du.c
>> +++ b/coreutils-6.9/src/du.c
>> +/* Insert new extent based on the new parent.  */
>> +
>> +static void
>> +insert_new_extent_info (struct rb_node *parent,
>> +                        uint64_t fe_physical,
>> +                        uint64_t fe_length,
>> +                        size_t extent_shared_count)
>> +{
>> +  struct rb_node **p = parent ? &parent : &((&fe_root)->rb_node);
>> +  struct rb_node *pp = NULL;
>> +  struct extent_info *this = NULL;
>> +  struct extent_info *ei;
>> +
>> +  while (*p)
>> +    {
>> +      pp = *p;
>> +      this = rb_entry (*p, struct extent_info, ei_node);
>> +
>> +      if (this->ei_physical > fe_physical)
>> +        p = &(*p)->rb_left;
>> +      else if (this->ei_physical < fe_physical)
>> +    p = &(*p)->rb_right;
>> +      else
>> +    return;
>>   
> I am just curious in your code the last "else" should never happen? If
> yes, maybe if we meet with this, it means a bug in the code.
> So better assert here?
IMHO, the last 'else' should not happen if the split algorithm works correctly.
The current algorithm is designed to make sure there is no extent overlap occurrs in the rbtree.
So I am prefer to abort the DU process by asserting there.

>> +    }
>> +
>> +/* Find the left-most position to insert.  */
>> +
>> +static struct rb_node *
>> +lookup_leftmost_extent_info (uint64_t fe_physical)
>> +{
>> +  struct rb_node **p = &((&fe_root)->rb_node);
>> +  struct rb_node *parent;
>> +  struct extent_info *this;
>> +
>> +  while (*p)
>> +    {
>> +      parent = *p;
>> +      this = rb_entry (*p, struct extent_info, ei_node);
>> +
>> +      if (this->ei_physical > fe_physical)
>> +       p = &(*p)->rb_left;
>> +      else if (this->ei_physical < fe_physical)
>> +    p = &(*p)->rb_right;
>> +      else
>> +    break;
>> +    }
>> +
>> +  return parent;
>>   
> If the rb-tree is empty, the parent is uninitialized. So please set
> parent to NULL in the declaration.
Thanks, this will be fixed in the next patches submit.

>> +}
>> +
>> +/* Split the new extent into mutiple items if there is overlap
>> +   with the search returned, insert each item or increase the
>> +   existed items shared count for the shared part.  */
>> +
>> +static void
>> +split_extent (uint64_t extent_physical_offset,
>> +              uint64_t extent_length)
>> +{
>> +  struct rb_node *parent = NULL;
>> +  struct rb_node *prev_parent = NULL;
>> +  struct extent_info *this;
>> +  uint64_t pb_start = extent_physical_offset;
>> +  uint64_t ext_len = extent_length;
>> +  uint64_t new_pb_start;
>> +  uint64_t new_ext_len;
>> +  uint64_t old_ext_len;
>> +  size_t ext_shared_count = 0;
>> +
>> +  parent = lookup_leftmost_extent_info (pb_start);
>> +
>>   +      /* The new extent physical offset if greater than the search
>> returned.
>> +         there are 3 scenarios need to check against the old one
>> which shown
>> +     as the following sketch.
>> +         |-----------| old
>> +           |----| new1
>> +           |-----------| new2
>> +           |---------------| new3.  */
>> +      if (pb_start < this->ei_physical + this->ei_length)
>> +        {
>> +      old_ext_len = this->ei_physical + this->ei_length - pb_start;
>> +      new_ext_len = MIN (ext_len, old_ext_len);
>> +
>> +          ext_shared_count = this->ei_shared_count;
>> +
>> +          /* The new extent overlapped with the old one, as a result, we
>> +         need to increase its shared count before inserting.  */
>> +          ext_shared_count++;
>> +      insert_new_extent_info (parent, pb_start, new_ext_len,
>> ext_shared_count);
>> +
>> +          /* Decrease the search returned extent size and keep it on
>> the tree.  */
>> +          this->ei_length = pb_start - this->ei_physical;
>> +
>> +      pb_start += new_ext_len;
>> +      ext_len -= new_ext_len;
>>   
> We also need prev_parent = parent here?
Yes, it needed.
By combining with your following next comments.
I will modify the logical as well.

>> +          parent = rb_next (parent);
>> +          continue;
>> +        }
>> +
>> +      prev_parent = parent;
>> +      parent = rb_next (parent);
>>   
> btw, in the above 3 cases, you always call "continue", so we have no
> chance to arrive here actually.
>> +    }
>> +}
>> +
>> +/* This function is called once for every file system object that fts
>> +   encounters, get its extent mapping info for the proceeding extent
>> +   spliting operation.  */
>> +
>> +static void
>> +process_extent(int cwd_fd, char const *file,
>> +               char const *file_full_name)
>> +{
>> +  char buf[4096] = "";
>> +  struct fiemap *fiemap = (struct fiemap *)buf;
>> +  struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
>> +  uint32_t count = (sizeof (buf) - sizeof (*fiemap)) /
>> +               sizeof (struct fiemap_extent);
>> +  int last = 0;
>> +
>> +  int fd = openat (cwd_fd, file, O_RDONLY);
>> +  if (fd < 0)
>> +    {
>> +      fd = open (file_full_name, O_RDONLY);
>> +      if (fd < 0)
>> +        {
>> +          error(0, errno, _("cannot open %s"), quote (file_full_name));
>> +          return;
>> +    }
>> +    }
>> +
>> +  memset (fiemap, 0, sizeof (*fiemap));
>> +
>> +  do {
>> +    fiemap->fm_length = ~0ULL;
>> +    fiemap->fm_flags = fiemap_bits_flags;
>> +    fiemap->fm_extent_count = count;
>> +
>> +    if (ioctl (fd, FS_IOC_FIEMAP, (unsigned long) fiemap) < 0)
>> +      {
>> +        if (errno == EBADR)
>> +            error (0, errno, _("%s FIEMAP failed with unsupported
>> flags %x\n"),
>> +                                quote (file_full_name),
>> fiemap->fm_flags);
>> +
>> +        error(0, errno, _("%s extent mapping failed"), quote
>> (file_full_name));
>> +        goto close_file;
>> +      }
>> +
>> +    /* If 0 extents are returned, then more ioctls
>> +       are not needed.  */
>> +    if (fiemap->fm_mapped_extents == 0)
>> +      goto close_file;
>> +
>> +    uint64_t ext_phy_offset;
>> +    uint64_t ext_len;
>> +    size_t i;
>>   
> better move these declaration above.
Do you means this is a bad coding style?

Due to these variables resides function exceeds 1 screen page, so I declares them here to
facilitate the variables reference like type and name. or else, someone have to page up to refer to
them.
I'd like to keep the ext_phy_offset and ext_len in the bottom FOR logical, but move 'i' to the
head of this function since it is well-known as an iterate counter.

How do you think about that?
I just want to make the code looks more professional.

>> +    for (i = 0; i < fiemap->fm_mapped_extents; i++)
>> +      {
            uint64_t ext_phy_offset;
            uint64_t ext_len;
>> +        ext_phy_offset = fm_ext[i].fe_physical;
>> +    ext_len = fm_ext[i].fe_length;
>> +
>> +        /* Skip inline file which its data mixed with metadata.  */
>> +        if (fm_ext[i].fe_flags & FIEMAP_EXTENT_DATA_INLINE)
>> +      {
>> +            if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
>> +              {
>> +                last = 1;
>> +                break;
>> +          }
>> +        continue;
>> +      }
>> +
>> +        /* Increase the shared extents size per file.  */
>> +        if (fm_ext[i].fe_flags & FIEMAP_EXTENT_SHARED)
>> +          file_shared_extents += fm_ext[i].fe_length;
>> +
>> +        split_extent (ext_phy_offset, ext_len);
>> +
>> +        if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
>> +          last = 1;
>> +
>> +        fiemap->fm_start = (fm_ext[i-1].fe_logical +
>> fm_ext[i-1].fe_length);
>>   
> I am just curious you start from i=0, so how could fm_ext[-1] work? Or I
> miss something here?
No, you are right, that's my mistake, the new start offset should be calcuated outside the FOR loop.

Thanks,
-Jeff

>> +      }
>> +    } while (last == 0);
>> +
>>   
> Regards,
> Tao
> 
