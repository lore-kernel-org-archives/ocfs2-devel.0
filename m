Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3685DC77B73
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u5b+X027AsIzSuWuq/DF8nmJXXaKzh1BzqbN/wIzSBs=;
 b=CyzwMggGHNgJrGNR7iO0YZeTfDpzMyVdpG58iapPMCP7y3b+3sR3Dxreg+dD2SNYApvb8f2qO5aL
   uEj+VNgIb6GHv7PcuoiEy2uB53LI7PnklYOh5wmnbSIOS0kk8rJsj3wmqYFZxX9U/Efha8GgODCk
   W9jsxTp7nDeSyUqVOinCwJ6lckyX6Pf8tmqR+cJ/o4VeMyz3x4iKpkyQdmLf18s4WYBW23MBBhhf
   oFxYntqAWuoiT4fqhOlaoJlTRUl33of3fbbGq8a/LdBL8MuxmOaIRwqqklp/JXGHggHSiwfs4TUb
   hDqC2gS1ch1xgTizsGiCTMylaVsk5eHD2QBLKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u5b+X027AsIzSuWuq/DF8nmJXXaKzh1BzqbN/wIzSBs=;
 b=cE72lC21/gyj+g9DPSZyTXlAgf2I6kFwO9wjiSUBQ8U9D5aMhA61pw6thIXcAiFY/QX/Cr0WSD1n
   nc4bemGk6A+XLS3bmUTef2aITG5p8PWN55xK8moxlESErxQARzLeLj5vMD84vWX9qo0VHe64nvB7
   f/ekpogYORnA5ME6F0TufSFqyuhjqcm1pQOctBN6iQN3WQ2H2cOKtuXLAXuOmIcWnZ8zg9f8cXT9
   4uGKBtEQcMs3fZmz560gdaUWiZbqmDxTWmt8KFZMdt2mO83Ww5seLW7MXa6tGGjkTEUf3RjzftcE
   rTuHJqigxIDFt+446iwU9K7bh4rp43ikw0+VxA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00KC3M171T20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:07 +0000 (GMT)
Message-id: <2fa31829-03f0-7bfb-a89b-e3917c479733@linux.alibaba.com>
Date: Fri, 10 Mar 2023 11:42:34 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
To: Al Viro <viro@zeniv.linux.org.uk>, Yangtao Li <frank.li@vivo.com>
References: <20230309152127.41427-1-frank.li@vivo.com>
 <20230309152127.41427-2-frank.li@vivo.com> <20230310031547.GD3390869@ZenIV>
In-reply-to: <20230310031547.GD3390869@ZenIV>
X-Source-IP: 115.124.30.113
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=115 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=104 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100027 domainage_hfrom=8730
Cc: brauner@kernel.org, tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 2/6] erofs: convert to use i_blockmask()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Gao Xiang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Gao Xiang <hsiangkao@linux.alibaba.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=20; SR=0;
 TI=SMTPD_---0VdVlEJ2_1678419754;
X-ServerName: out30-113.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: oOQoIf9J7A0zm9kk4C8puK6Ue1ALld73
X-Proofpoint-ORIG-GUID: oOQoIf9J7A0zm9kk4C8puK6Ue1ALld73
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAFlzmelxJYUdzSHAgGvziIcTlKXWfVv6VJzwfs81Z/WOU2w9Zp5jRQAyHpQ8EHf
 e3nAvPsXt2282S03ZKl5tNmSV/lARUO4WGhkhYAwR+p69hQAWynpuspEsj++xnLJ
 y+oLcy2nbSATDWBcqSirxYD37zLuI9BU2vGjErOuBFJQrFEiX6/afDLPKx4Nu0A8
 Y9FMmgx9lL/gKwAMHgDvZiTc4m1OKlemdavuxUHx2iDc2Kj0/vFvxDh6hK/Q3vl9
 ++mRNwnbVtHeB1gQlYq2IG2foK5OP3uFCbBO8YxB46FP1Dw5JmTYSCcX7vD6rDZS
 KAWONN2R0Ny9fGurTLaw9JEFEdBbhO/CLURinTBqsHWHjDhNLlvKCejpjR6I5I/z
 soQDWXszjPaRNmgHtTmotMh9iuv13eEaqVXYnrP3wA9R2FMCA2c3F8s9FmcLFmCa
 UKI17UHN6wAHdOeQifs0vBo6lnnUmur2o1/OCTikbG6BBWCydtSIJcqY85yVY5Jk
 iLwKRjIrklpGhwc+QM3FHHvOl5eQj1QCk4OpurNwBP0ULQ==

Hi Al,

On 2023/3/10 11:15, Al Viro wrote:
> On Thu, Mar 09, 2023 at 11:21:23PM +0800, Yangtao Li wrote:
>> Use i_blockmask() to simplify code.
> 
> Umm...  What's the branchpoint for that series?  Not the mainline -
> there we have i_blocksize() open-coded...

Actually Yue Hu sent out a clean-up patch and I applied to -next for
almost a week and will be upstreamed for 6.3-rc2:

https://lore.kernel.org/r/a238dca1-256f-ae2f-4a33-e54861fe4ffb@kernel.org/T/#t

And then Yangtao would like to wrap this as a new VFS helper, I'm not
sure why it's necessary since it doesn't save a lot but anyway, I'm open
to it if VFS could have such new helper.

Thanks,
Gao Xiang

> 
>> Signed-off-by: Yangtao Li <frank.li@vivo.com>
>> ---
>> v3:
>> -none
>> v2:
>> -convert to i_blockmask()
>>   fs/erofs/data.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
>> index 7e8baf56faa5..e9d1869cd4b3 100644
>> --- a/fs/erofs/data.c
>> +++ b/fs/erofs/data.c
>> @@ -380,7 +380,7 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   		if (bdev)
>>   			blksize_mask = bdev_logical_block_size(bdev) - 1;
>>   		else
>> -			blksize_mask = i_blocksize(inode) - 1;
>> +			blksize_mask = i_blockmask(inode);
>>   
>>   		if ((iocb->ki_pos | iov_iter_count(to) |
>>   		     iov_iter_alignment(to)) & blksize_mask)
>> -- 
>> 2.25.1
>>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
