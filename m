From: Changwei Ge <ge.changwei@h3c.com>
Date: Sat, 10 Nov 2018 07:58:28 +0000
Subject: [Ocfs2-devel] [PATCH RESEND] ocfs2: fix a misuse a of brelse
 after failing ocfs2_check_dir_entry
References: <HK2PR06MB045211675B43EED794E597B6D56E0@HK2PR06MB0452.apcprd06.prod.outlook.com>
	<5BE67BD4.2020703@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37301277E2772@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: piaojun <piaojun@huawei.com>, Changwei Ge <gechangwei@live.cn>, Andrew Morton <akpm@linux-foundation.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>, "jiangqi903@gmail.com" <jiangqi903@gmail.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>

Hi Jun,

Thanks for looking into this, my code from Linux mainline is not looked like yours...

On 2018/11/10 14:36, piaojun wrote:
> Hi Changwei,
> 
> On 2018/5/28 22:40, Changwei Ge wrote:
>> From: Changwei Ge <ge.changwei@h3c.com>
>>
>> Somehow, file system metadata was corrupted, which causes
>> ocfs2_check_dir_entry() to fail in function ocfs2_dir_foreach_blk_el().
>>
>> According to the original design intention, if above happens we should
>> skip the problematic block and continue to retrieve dir entry. But there
>> is obviouse misuse of brelse around related code.
>>
>> After failure of ocfs2_check_dir_entry(), currunt code just moves to next
>> position and uses the problematic buffer head again and again during
>> which the problematic buffer head is released for multiple times. I
>> suppose, this a serious issue which is long-lived in ocfs2. This may
>> cause other file systems which is also used in a the same host insane.
>>
>> So we should also consider about bakcporting this patch into
>> linux -stable.
>>
>> Suggested-by: Changkuo Shi <shi.changkuo@h3c.com>
>> Cc: stable at vger.kernel.org
>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>> ---
>>   fs/ocfs2/dir.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index b048d4f..c121abb 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -1897,8 +1897,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
>>   				/* On error, skip the f_pos to the
>>   				   next block. */
>>   				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
>> -				brelse(bh);
>> -				continue;
>> +				break;
> 
> I guess return is more appropriate than break here as it will cause double
> free buffer:
> 
> "
> ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
> brelse(bh);
> break;
> "

Linux mainline should not have 'brelse(bh)', could your please rebase your tree?

'''
ccd979bdb (Mark Fasheh         2005-12-15 14:31:24 -0800 1897)                          /* On error, skip the f_pos to the
ccd979bdb (Mark Fasheh         2005-12-15 14:31:24 -0800 1898)                             next block. */
3704412bd (Al Viro             2013-05-22 21:06:00 -0400 1899)                          ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
29aa30167 (Changwei Ge         2018-11-02 15:48:15 -0700 1900)                          break;
'''
> 
> "
> brelse(bh);
> bh = NULL;
> if (!persist && stored)
> 	break;
> "
> 
> Thanks,
> Jun
> 
>>   			}
>>   			if (le64_to_cpu(de->inode)) {
>>   				unsigned char d_type = DT_UNKNOWN;
>>
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
