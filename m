From: Coly Li <coly.li@suse.de>
Date: Fri, 26 Mar 2010 05:20:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: one more warning fix in
	ocfs2_file_aio_write()
In-Reply-To: <20100325204515.GB9984@mail.oracle.com>
References: <4BABC5D3.50400@suse.de> <20100325204515.GB9984@mail.oracle.com>
Message-ID: <4BABD388.9020107@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2010?03?26? 04:45, Joel Becker Wrote:
> On Fri, Mar 26, 2010 at 04:21:39AM +0800, Coly Li wrote:
>> This patch fixes another compiling warning in ocfs2_file_aio_write() like this,
>>     fs/ocfs2/file.c: In function ?ocfs2_file_aio_write?:
>>     fs/ocfs2/file.c:2026: warning: suggest parentheses around ?&&? within ?||?
>>
>> Signed-off-by: Coly Li <coly.li@suse.de>
>> ---
>>  fs/ocfs2/file.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 17947dc..c4638fd 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -2021,8 +2021,8 @@ out_dio:
>>  		if (ret < 0)
>>  			written = ret;
>>
>> -		if (!ret && (old_size != i_size_read(inode) ||
>> -		    old_clusters != OCFS2_I(inode)->ip_clusters ||
>> +		if ((!ret) && ((old_size != i_size_read(inode)) ||
> 
> 	You don't need to wrap the !ret.  It's unary.
> 

Just posted another update, and Cc to you.
Thanks for the review :-)
-- 
Coly Li
SuSE Labs
