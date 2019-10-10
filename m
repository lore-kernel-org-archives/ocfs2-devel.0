From: Changwei Ge <gechangwei@live.cn>
Date: Thu, 10 Oct 2019 10:05:29 +0000
Subject: [Ocfs2-devel] (RESEND) [PATCH] ocfs2: Fix error handling in
 ocfs2_setattr()
In-Reply-To: <6c6a49dd-f1e6-da3e-8481-071071c91b06@gmail.com>
References: <20191010082349.1134-1-cgxu519@mykernel.net>
	<6c6a49dd-f1e6-da3e-8481-071071c91b06@gmail.com>
Message-ID: <HK0PR02MB378041C674F12FF50C672E05D5940@HK0PR02MB3780.apcprd02.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <jiangqi903@gmail.com>, Chengguang Xu <cgxu519@mykernel.net>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


On 2019/10/10 4:49 ??, Joseph Qi wrote:
>
> On 19/10/10 16:23, Chengguang Xu wrote:
>> Should set transfer_to[USRQUOTA/GRPQUOTA] to NULL
>> on error case before jump to do dqput().
>>
>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> Looks good.
>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>


Also looks sane to me

Reviewed-by: Changwei Ge <chge@linux.alibaba.com>



>> ---
>>   fs/ocfs2/file.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 2e982db3e1ae..53939bf9d7d2 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1230,6 +1230,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>   			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
>>   			if (IS_ERR(transfer_to[USRQUOTA])) {
>>   				status = PTR_ERR(transfer_to[USRQUOTA]);
>> +				transfer_to[USRQUOTA] = NULL;
>>   				goto bail_unlock;
>>   			}
>>   		}
>> @@ -1239,6 +1240,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>   			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
>>   			if (IS_ERR(transfer_to[GRPQUOTA])) {
>>   				status = PTR_ERR(transfer_to[GRPQUOTA]);
>> +				transfer_to[GRPQUOTA] = NULL;
>>   				goto bail_unlock;
>>   			}
>>   		}
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
