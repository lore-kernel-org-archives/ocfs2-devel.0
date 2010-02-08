From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 08 Feb 2010 16:20:47 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] du_enhancement: show the shared
 extents per file and the footprint
In-Reply-To: <1264492809-13848-4-git-send-email-jeff.liu@oracle.com>
References: <>
	<1264492809-13848-1-git-send-email-jeff.liu@oracle.com>	<1264492809-13848-2-git-send-email-jeff.liu@oracle.com>	<1264492809-13848-3-git-send-email-jeff.liu@oracle.com>
	<1264492809-13848-4-git-send-email-jeff.liu@oracle.com>
Message-ID: <4B6FC95F.205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff,
	Thanks for the work. and sorry for the delay of review.

Jeff Liu wrote:
> this patch add fiemap feature support in du, du show the shared extents size in parens per file
> as well as the footprint for each request with either '--shared-size' or '-E' option.
> 
> the footprint which is total minus the sum total of all extents in the rbtree
> that have ei_shared_count > 0.
> 
> Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
> ---
>  lib/rbtree.h |    4 +-
>  src/du.c     |  378 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 378 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/rbtree.h b/lib/rbtree.h
> index ad646b1..bb23391 100644
> --- a/lib/rbtree.h
> +++ b/lib/rbtree.h
> @@ -112,8 +112,8 @@ struct rb_root
>    };
>  
>  #define RB_ROOT	(struct rb_root) { NULL, }
> -#define	rb_entry (ptr, type, member)                              \
> -  ((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
> +#define	rb_entry(ptr, type, member) \
> +	((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
I haven't found what you change for this 2 lines. Just change the place 
of '\"?
>  
>  extern void rb_insert_color (struct rb_node *, struct rb_root *);
>  extern void rb_erase (struct rb_node *, struct rb_root *);
<snip>
> +/* Split the new extent into mutiple items if there is overlap
> +   with the search returned, insert each item  or increase the
> +   existed items shared count for the shared part.  */
> +
> +static void
> +split_extent (uint64_t extent_physical_offset,
> +              uint64_t extent_length)
> +{
> +  struct rb_node *parent = NULL;
> +  struct rb_node *prev_parent = NULL;
> +  struct extent_info *this;
> +  uint64_t pb_start = extent_physical_offset;
> +  uint64_t ext_len = extent_length;
> +  uint64_t new_pb_start;
> +  uint64_t new_ext_len;
> +  uint64_t old_ext_len;
> +  size_t ext_shared_count = 0;
> +
> +  parent = lookup_leftmost_extent_info (pb_start);
> +
> +  while (ext_len)
> +    {
> +      if (!parent)
> +        {
> +          insert_new_extent_info (prev_parent, pb_start, ext_len, ext_shared_count);
> +	  break;
> +	}
> +
> +      this = rb_entry (parent, struct extent_info, ei_node);
> +
Could you please add more comments on the later codes? It is a little 
complicated for analysis.
> +      if (pb_start < this->ei_physical)
> +	{
> +	  new_ext_len = min (this->ei_physical - pb_start, ext_len);
> +          insert_new_extent_info (parent, pb_start, new_ext_len, ext_shared_count);
here is a bug, you need to set ext_shared_count to 0 since the later 
code will change it.
> +
> +          pb_start += new_ext_len;
> +	  ext_len -= new_ext_len;
> +          continue;
> +        }
> +
> +      if (pb_start == this->ei_physical)
> +        {
> +	  ext_shared_count = this->ei_shared_count;
> +          old_ext_len = this->ei_length;
> +          new_ext_len = min (ext_len, this->ei_length);
> +
> +          this->ei_length = new_ext_len;
> +          this->ei_shared_count++;
> +
> +          pb_start += new_ext_len;
> +          ext_len -= new_ext_len;
> +
> +          if (old_ext_len > new_ext_len)
> +            {
> +	      new_pb_start = this->ei_physical + this->ei_length;
> +	      new_ext_len = old_ext_len - new_ext_len;
> +	      insert_new_extent_info (parent, new_pb_start, new_ext_len, ext_shared_count);
here you have add a new extent info but forget to increase pb_start and 
decrease ext_len. Also we need to reset ext_shared_count to 0 before insert.
> +	    }
> +
> +          prev_parent = parent;
> +          parent = rb_next (parent);
> +          continue;
> +        }
> +
> +      if (pb_start < this->ei_physical + this->ei_length)
> +        {
> +	  old_ext_len = this->ei_physical + this->ei_length - pb_start;
> +	  new_ext_len = min (ext_len, old_ext_len);
> +
> +          ext_shared_count = this->ei_shared_count;
> +	  if (new_ext_len < old_ext_len)
> +            insert_new_extent_info (parent, pb_start, new_ext_len, ext_shared_count);
> +	  else
> +	    insert_new_extent_info (parent, pb_start, old_ext_len, ext_shared_count);
We need to ext_shared_count++ for the insert_new_extent_info?
btw, only one line is enough:
insert_new_extent_info(parent, pb_start, new_ext_len, ext_shared_count);
new_ext_len is <= old_ext_len because of the above min, so we are safe 
for the above 2 cases.
> +
> +          this->ei_length = pb_start - this->ei_physical;
> +
> +	  pb_start += new_ext_len;
> +	  ext_len -= new_ext_len;
> +          parent = rb_next (parent);
> +          continue;
> +        }
> +
> +      prev_parent = parent;
> +      parent = rb_next (parent);
> +    }
> +}

Regards,
Tao
