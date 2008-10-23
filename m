From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 23 Oct 2008 18:06:37 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: add array bounds checking
In-Reply-To: <20081023093026.GG1580@mail.oracle.com>
References: <49003524.3090405@oracle.com>
	<1224750884-10976-1-git-send-email-tiger.yang@oracle.com>
	<20081023093026.GG1580@mail.oracle.com>
Message-ID: <49004CAD.6010308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for your quick review and suggestion.
I think your solutions is better than mine. It's more simple.

thanks,
tiger

Joel Becker wrote:
> On Thu, Oct 23, 2008 at 04:34:44PM +0800, Tiger Yang wrote:
>> This could avoid arry bounds exceeded issue.
>>
>> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
>> ---
>>  fs/ocfs2/xattr.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 754e5fa..888641d 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -164,7 +164,7 @@ static inline const char *ocfs2_xattr_prefix(int name_index)
>>  {
>>  	struct xattr_handler *handler = NULL;
>>  
>> -	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
>> +	if (name_index > 0 && name_index < ARRAY_SIZE(ocfs2_xattr_handler_map))
>>  		handler = ocfs2_xattr_handler_map[name_index];
> 
> 	Another option is to define the map as:
> 
> static struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_ATTR_MAX] = {
> 
> This reuses our nice OCFS2_XATTR_MAX value.  But both methods work.
> 
> Joel
> 
