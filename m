Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A067C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 18 Nov 2022 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y3QyNgTJ/DrInrswDC07jJ31ypqg1wF7MlnbUxo8X9c=;
 b=GPQqjRruJJiO3Gs7cNHCjRdAhB3E0kGOBidsk78eA1q492U1p4MoNt0ag/DhtXPiLOID6HjygZKp
   /iFGeMghVSa4gFVd+5+gk6IeoOhCtkHiA/ywBVkajWV/tfn6mae8V0Ka9eI3P4zHVYvftXSgwXD6
   F5TEpV/cfOXrMcYrCpTTErEFgQ2HN8Kvf4C2nFm4sRB6ml5oGFfCA92jGa6qGc+Smb9RgAG6YTeH
   sCJ22zIKgWuDAmcqOEz9FEzgl99nSUZpSwBOW9Y88/0E6zE/EQ5NDLY7wwbcuc2MU9Vmt82bLVAT
   gKebhLJiqErnB1GfkGJaUWJu9yP5ECSPsAaAxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=y3QyNgTJ/DrInrswDC07jJ31ypqg1wF7MlnbUxo8X9c=;
 b=WDDTC5iPuQ9nDc/zEyHKWhf9JiZb3LixERqLSxEfXmhGBc7Vv0RV60M73oeILc36HEVkNJJrmZHO
   xvyIOVvZfh5O55/wTABpejXVxMyhCrQrqdQlGWtIN9fTWPC4QDlcN+Jobbvx3Sv9y6hqoE92Knv/
   msFxFc6GLJ7Ee/F5p9Od9ZtD2mmhYNDRh6dM0zX071dLQGs0aoYf40g0UupvBczwu1VpekB/pkLW
   WXaLjDK6ime5k2URaybMnghFCkp/6W+2r9WjHld5pFygQYwn7yrqT4PeWGnOKl/GhTGFDi8Y5UYq
   pNzv5Sy/vah30ImpKAkXs2EeAYmNzltbBeQl2w==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLJ00A5GVX93600@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 18 Nov 2022 15:48:45 +0000 (GMT)
Message-id: <5758e5c4-9c8b-4492-3ecd-ba6607fc2899@huaweicloud.com>
Date: Fri, 18 Nov 2022 10:04:37 +0100
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Content-language: en-US
To: Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
 <20221110094639.3086409-3-roberto.sassu@huaweicloud.com>
 <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
In-reply-to: <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10534
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 priorityscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=756 bulkscore=0 suspectscore=0 clxscore=8 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211180055
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] security: Rewrite
 security_old_inode_init_security()
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: LxC2BwBHMW6oSndjv7Z0AA--.22042S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCry7Xw15Zr18Zw4fWF17Jrb_yoW5Jw48pF
 W2kF1DKrs8JF97CrZ7trnrWF4xKayrGrZrXws3Ary7ZFn8CFn7tr40yry3Ca43GrW8J34F
 qw43Z343Zrn8Z3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
 07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
 02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
 WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
 CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
 14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
 9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAABF1jj4GVFAACs1
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: G5Kv4lWzQwXHSADk4X7KcnaGYOu70aI_
X-Proofpoint-ORIG-GUID: G5Kv4lWzQwXHSADk4X7KcnaGYOu70aI_
X-Mailman-Approved-At: Fri, 18 Nov 2022 15:48:44 +0000
Reporting-Meta:
 AAGsK33I+3VzkPM0GmqYZx7siN+xNGjCz/bioKdlMjfM7iigzDW1VDJk7reaP8yQ
 x4xz5b24K6rqnk3KcDoiahtnzOSmOgSXRtozgaSskLINSAKz3tQILKVTfzJTx4cZ
 3t1fUcF4EUGiLm7QdE3N7C4l9jOnzkTn6d6+BnIto+lnskKU6GCmDfWe4aBOfz1z
 xqDVj+AzpFvMo35/P+TOlrxiGVCNgxUHyhE+Lc+8R1xP5F92Ioc1w6lbYGuhN9rS
 hYxWWK25gX/jpYt6zaT+anZj3zMe8p41TgPSeW4BmW/4AgQdvmk1lUYVjmFdT8CM
 NLo9C63UeCwhZd+xtBAlEI7BU4Hyp1iX+St7ykkBCX8jhpet2gfUd4xC8aVo5x51
 A7HUcnJAj9Ip1RO0HyTQ8wtc1xOtN7X9q13TyfHOIysmnM5ZqCYTzjFbkNNbcj2o
 qHNFxsAJ7hQRiN/coA5/NK02MYpExnH0xDK60ykKIcwKVVfdf5jaU3vVOOZgHS70
 pwrFnzoUrJ0KGH+aHYTTM3xjWWlFsMILD9M1bY7jCNY=

On 11/17/2022 2:03 PM, Mimi Zohar wrote:
> Hi Roberto,
> 
> On Thu, 2022-11-10 at 10:46 +0100, Roberto Sassu wrote:
>> From: Roberto Sassu <roberto.sassu@huawei.com>
>>
>> Rewrite security_old_inode_init_security() to call
>> security_inode_init_security() before making changes to support multiple
>> LSMs providing xattrs. Do it so that the required changes are done only in
>> one place.
> 
> Only security_inode_init_security() has support for EVM.   Making
> security_old_inode_init_security() a wrapper for
> security_inode_init_security() could result in security.evm extended
> attributes being created that previously weren't created.

Hi Mimi

yes, I thought about this problem. In fact, it should not matter too 
much. Since security_old_inode_init_security() supports setting only one 
xattr: if there is an LSM xattr, that one will be set, and the EVM one 
will be discarded; if there is no LSM xattr, EVM would not add one.

> In fact ocfs2 defines ocfs2_init_security_get() as a wrapper for both
> the old and new inode_init_security calls based on the caller's
> preference.   Only mknod and symlink seem to use the old function.
> Wondering why do they differentiate between callers?  (Cc'ing the ocfs2
> mailing list as they're affected by this change.)
> 
> "[PATCH v4 1/5] reiserfs: Add missing calls to
> reiserfs_security_free()"  fixed a memory leak.  I couldn't tell if
> there was a similar memory leak in ocfs2, the only other user of
> security_old_inode_init_security().

Will look into it.

> As ocfs2 already defines initxattrs, that leaves only reiserfs missing
> initxattrs().  A better, cleaner solution would be to define one.

Yes, great idea!

Thanks

Roberto

> thanks,
> 
> Mimi
> 
>>
>> Define the security_initxattrs() callback and pass it to
>> security_inode_init_security() as argument, to obtain the first xattr
>> provided by LSMs.
>>
>> This behavior is a bit different from the current one. Before this patch
>> calling call_int_hook() could cause multiple LSMs to provide an xattr,
>> since call_int_hook() does not stop when an LSM returns zero. The caller of
>> security_old_inode_init_security() receives the last xattr set. The pointer
>> of the xattr value of previous LSMs is lost, causing memory leaks.
>>
>> However, in practice, this scenario does not happen as the only in-tree
>> LSMs providing an xattr at inode creation time are SELinux and Smack, which
>> are mutually exclusive.
>>
>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
