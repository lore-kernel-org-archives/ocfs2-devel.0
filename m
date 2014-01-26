From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sat, 25 Jan 2014 19:18:11 -0600
Subject: [Ocfs2-devel] [patch 01/11] ocfs2: fix ocfs2_sync_file() if
 filesystem is readonly
In-Reply-To: <20140124143204.03ee21c5d6e9eabda00f9628@linux-foundation.org>
References: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>	<52E2E2E1.2060601@suse.de>	<20140124222119.GF24361@wotan.suse.de>
	<20140124143204.03ee21c5d6e9eabda00f9628@linux-foundation.org>
Message-ID: <52E46253.5000205@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/24/2014 04:32 PM, Andrew Morton wrote:
> On Fri, 24 Jan 2014 14:21:19 -0800 Mark Fasheh <mfasheh@suse.de> wrote:
>
>> On Fri, Jan 24, 2014 at 04:02:09PM -0600, Goldwyn Rodrigues wrote:
>>>
>>>
>>> On 01/24/2014 02:46 PM, akpm at linux-foundation.org wrote:
>>>> From: Younger Liu <younger.liucn@gmail.com>
>>>> Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly
>>>>
>>>> If filesystem is readonly, there is no need to flush drive's caches or
>>>> force any uncommitted transactions.
>>>
>>> An ocfs2 filesystem can be set to read-only because of an error, in
>>> which case, you should return -EROFS.
>>>
>>> Nak.
>>
>> Goldwyn's right actually - disregard my sign off for the last one.
>>
>> Basically the patch does this:
>>
>>      if  (we're in some readonly state)
>> 	return 0;
>>
>> What we want, at the top of ocfs2_sync_file() is a return of -EROFS. This
>> will satisfy Goldwyn's requirement that we bubble -EROFS up the stack but at
>> the same time avoiding the extra work of trying to sync on a RO fs.
>>
>> So the new version of the patch would be:
>>
>>      if  (we're in some readonly state)
>> 	return -EROFS;
>>
>
> So it's this?
>

Yes.

Acked-by: Goldwyn Rodrigues <rgoldwyn@suse.de>


> --- a/fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly
> +++ a/fs/ocfs2/file.c
> @@ -185,6 +185,9 @@ static int ocfs2_sync_file(struct file *
>   			      file->f_path.dentry->d_name.name,
>   			      (unsigned long long)datasync);
>
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +		return -EROFS;
> +
>   	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
>   	if (err)
>   		return err;
> _
>


-- 
Goldwyn
