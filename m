From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 30 Jun 2010 09:34:30 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Add struct file to
	ocfs2_refcount_cow.
In-Reply-To: <20100629231453.GH4150@mail.oracle.com>
References: <4C29AE6C.1050205@oracle.com>
	<1277800541-6844-1-git-send-email-tao.ma@oracle.com>
	<20100629231453.GH4150@mail.oracle.com>
Message-ID: <4C2A9F26.2020302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 06/30/2010 07:14 AM, Joel Becker wrote:
> On Tue, Jun 29, 2010 at 04:35:38PM +0800, Tao Ma wrote:
>> Add a new parameter 'struct file *' to ocfs2_refcount_cow
>> so that we can add readahead support later.
>>
>> Signed-off-by: Tao Ma<tao.ma@oracle.com>
>> ---
>>   fs/ocfs2/aops.c         |    2 +-
>>   fs/ocfs2/file.c         |   13 ++++++++-----
>>   fs/ocfs2/refcounttree.c |    4 +++-
>>   fs/ocfs2/refcounttree.h |    3 ++-
>>   4 files changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 4dfaa6e..5f94923 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -1691,7 +1691,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   		mlog_errno(ret);
>>   		goto out;
>>   	} else if (ret == 1) {
>> -		ret = ocfs2_refcount_cow(inode, di_bh,
>> +		ret = ocfs2_refcount_cow(inode, NULL, di_bh,
>>   					 wc->w_cpos, wc->w_clen, UINT_MAX);
>
> 	You should be replacing the inode parameter with the file
> parameter.  You can always get back to the inode from the filp.  When I
> first saw this, I had to read through your entire series to figure out
> if a NULL filp was valid.  It's not.  In the end, you change
> write_begin_nolock() to take (inode, filp), which is pointless, because
> write_begin() always gets a valid filp.  So does page_mkwrite().
> 	So in your first patch of the series, change
> ocfs2_write_begin_nolock() and __ocfs2_page_mkwrite() to take the filp
> instead of the inode.  Then in your later patches you can always expect
> the filp to be valid.
make sense. I will change it. thanks.

btw, I forget to say this series is targeted to the next merge window. ;)

Regards,
Tao
>
> Joel
>
