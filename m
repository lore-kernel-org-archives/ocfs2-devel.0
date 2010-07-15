From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 15 Jul 2010 14:24:29 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: don't overwrite error codes in
 ocfs2_init_acl
In-Reply-To: <4C3DD0A6.4050902@oracle.com>
References: <4C3D8D53.7010400@oracle.com> <4C3DD0A6.4050902@oracle.com>
Message-ID: <4C3F7C8D.1010604@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Good catch.

On 07/14/2010 07:58 AM, Tao Ma wrote:
> Hi Tiger,
> Tiger Yang wrote:
>    
>> Hi, all,
>>
>> Pawel(pzlist at mp.pl) reported a bug in ocfs2 acl. This patch fix this
>> issue.
>>
>> Thanks,
>> tiger
>>      
> @@ -381,7 +381,11 @@ int ocfs2_init_acl(handle_t *handle,
>
>   		mode = inode->i_mode;
>   		ret = posix_acl_create_masq(clone,&mode);
>   		if (ret>= 0) {
> -			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
> +			ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
> +			if (ret2) {
> +				mlog_errno(ret2);
> You need to set ret = ret2 here so that we can return the error value to the caller.
> +				goto cleanup;
> +			}
>   			if (ret>  0) {
>   				ret = ocfs2_set_acl(handle, inode,
>   						    di_bh, ACL_TYPE_ACCESS,
>
> Regards,
> Tao
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>    
