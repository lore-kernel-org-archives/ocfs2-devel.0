Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDBBECAAD2
	for <ocfs2-devel@archiver.kernel.org>; Fri,  2 Sep 2022 01:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NmDoN/BV2Cu55wf22KKBu626atScedvM6PXnVhzfB4I=;
 b=g94yHkpcW+BQIr6XdG7697cIRvi5fGFZSMo/Zg9kVQUSDtkJU8m27oZ5y4IIvBMOApOeDeoSgWA+
   +8pZZT/qOX6TZDpPMvKyuAEloaF/TTWPOpLu0qqXYkhKlpLDPWctDw9NVSzh/XBCF3wM1o01HqZr
   1BiIVDPQSdFKgHoKYa8fZxnXrIysBvtZDZVRkOkfHOEMoYi79FasZpMC7Ny8eMeyHkGShzP4GLlC
   86iqlB49qsnge7LDG9RmZvQV+uhSEKQ6dttR6w/BynWTs6U+ohB50olKDvclgmbp9eo9rT5XgUp0
   uTODymsySV3ZpEwWF2+na09njSbbW+ZpvOn0Gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NmDoN/BV2Cu55wf22KKBu626atScedvM6PXnVhzfB4I=;
 b=Rdthqtm2OmfvzpGn7P1Y2nrAs1YjsBiR7sW5IxZQn1R8ajTAAJ6786OsWJfQPPvdMEx9WPNbzYk5
   xvOMzv0hDa8WpYewIqzCHzIwSbB0w6eZh6ur0gGLJO9npp9v/XNormnuWceFiz+cXbUnOBd6Fd8K
   nvbz0qbH9x1nnFnwj9nkzCczq0fJtEAcmLXgKRIdL/+69KEnslczogqI2aKsOz4fcSRrJ15P5ydV
   vzYHnS4+fw9ezrCtwd+PD25RaLzFYxbT4VVlgG9lF+aFZpRfxE4qVtUFCfpToWQPBDCA9bXgVESa
   Bi/4RenpwEg4WVzGYFs9tT4VJVNamPOMSx+pYQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHK00J4Z868TJ70@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 02 Sep 2022 01:58:56 +0000 (GMT)
To: Al Viro <viro@zeniv.linux.org.uk>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-14-yi.zhang@huawei.com> <YxFOqimAyJNxuPM9@ZenIV>
 <3fdab5fd-1efa-9668-da5c-889e9bfa1524@huawei.com> <YxFhi1iJ2cFfKi04@ZenIV>
Message-id: <e1dbafd4-4696-3c3f-ac0d-6fc7d06c9b58@huawei.com>
Date: Fri, 2 Sep 2022 09:58:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-version: 1.0
In-reply-to: <YxFhi1iJ2cFfKi04@ZenIV>
Content-language: en-US
X-Originating-IP: [10.174.178.134]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 clxscore=95 malwarescore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=696 phishscore=0 suspectscore=0
 priorityscore=239 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020007 domainage_hfrom=8270
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 yukuai3@huawei.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
 linux-ext4@vger.kernel.org, dushistov@mail.ru, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 13/14] ext2: replace bh_submit_read()
 helper with bh_read_locked()
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
From: Zhang Yi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zhang Yi <yi.zhang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: 4Lg3WT4byRA21FsNamQqsjNuYFWDXqWA
X-Proofpoint-ORIG-GUID: 4Lg3WT4byRA21FsNamQqsjNuYFWDXqWA
Reporting-Meta:
 AAErGDA3O1D/SObsFaG29ZwMJBwi53DZJAAAOySRwExu/VXzX/Vx2O5qBlrx63Ef
 TD7mrT9LUL7gXZiARekU8WIVSSBLDsyHA7csNWI61jTzmeIVmCNgswngrqmth6fC
 abzKD/ZCcVot0YIlFJdbpEcnL7CjM8fh7WACmCii+rQh2mdPs8pS93Lc90/Zw9IE
 zAVGZSobjqVLZpS9ObGo5PFAr/L3Uq+1qrU/bCTXvnhuTPYYZmYB1/gfiD9gVWhM
 hyf8pag9TxVzWwalpSjloKe3YUvpcA0BkCZjspaJkdCAh9/PlTx4OPKJ/0+WHXFa
 S8ZpQRVCegu/jYHNRUpw6OC/7xD+C2F9Q2g7HdUILJ+QIEm4OXg5Y0aDEBka1XQP
 iBoaVgFC6s0BP05/nganUB27DmVgSM3V5I318Lro6P6clUwL7dZFCFPYK120R1J+
 gqPcmoRwO/GRli6HSr7OLB8b136on1U1HL0xZW8jARb6l9jwDvbn4bHOAxdLCnZR
 p9pSRwJJB4Flb+9xBze+EUaSOqhL0qXHzgjCPaxsldgXLw==



On 2022/9/2 9:51, Al Viro wrote:
> On Fri, Sep 02, 2022 at 09:32:53AM +0800, Zhang Yi wrote:
>> On 2022/9/2 8:30, Al Viro wrote:
>>> On Thu, Sep 01, 2022 at 09:35:04PM +0800, Zhang Yi wrote:
>>>> bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
>>>> has been integrated in bh_read() helper, so switch to use it directly.
>>>
>>> s/bh_read_locked/bh_read/ in the summary?
>>>
>>
>> Sorry, I don't get your question, I have already replace bh_read_locked()
>> with bh_read() in the commit message, there is no bh_read_locked in the whole
>> patch. Am I missing something?
> 
> Take a look at the subject ;-)

Oh, yes, I forgot to update the subject, will do.

Thanks,
Yi.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
