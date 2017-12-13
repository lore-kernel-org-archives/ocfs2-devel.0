From: alex chen <alex.chen@huawei.com>
Date: Wed, 13 Dec 2017 15:49:51 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: using the OCFS2_XATTR_ROOT_SIZE
	macro in ocfs2_reflink_xattr_header()
In-Reply-To: <20171212144747.f35e16dfcd2a0b90c18e0479@linux-foundation.org>
References: <5A2E2488.70301@huawei.com>
	<20171212144747.f35e16dfcd2a0b90c18e0479@linux-foundation.org>
Message-ID: <5A30DB9F.6040506@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

Thanks for your suggestion.

On 2017/12/13 6:47, Andrew Morton wrote:
> On Mon, 11 Dec 2017 14:24:08 +0800 alex chen <alex.chen@huawei.com> wrote:
> 
>> Using the OCFS2_XATTR_ROOT_SIZE macro improves the readability of the code.
>>
>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>> Reviewed-by: Jun Piao <piaojun@huawei.com>
>> ---
>>  fs/ocfs2/xattr.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 5fdf269..ca3b61a 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -6415,7 +6415,7 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
>>  		 * and then insert the extents one by one.
>>  		 */
>>  		if (xv->xr_list.l_tree_depth) {
>> -			memcpy(new_xv, &def_xv, sizeof(def_xv));
>> +			memcpy(new_xv, &def_xv, OCFS2_XATTR_ROOT_SIZE);
>>  			vb->vb_xv = new_xv;
>>  			vb->vb_bh = value_bh;
>>  			ocfs2_init_xattr_value_extent_tree(&data_et,
> 
> OK.
> 
> But what's wrong with
> 
> 	*new_xv = def_xv;
> 
> ?

The type of new_xv is 'ocfs2_xattr_value_root' and the type of def_xv is 'ocfs2_xattr_def_value_root'.
The length of def_xv is larger than that of new_xv.
We initialize the new_xv to the empty default value root which have one extent record.
If we use method you describe above to copy, we may missed a copy of one extent record.

Thanks,
Alex
> 
> That gets typechecked and the compiler may be able to perform
> some optimizations...
> 
> 
> .
> 
