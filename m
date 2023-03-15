Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6160CC6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Wed, 15 Mar 2023 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bbDvOgnNnW8MCpRis/mPktDEr89/opcmRz3rf27OXpQ=;
 b=JWKoIS5S5uceTQjIrk9Zr2zdkDPr9hef/Zv1ErTu64LI7WiTwEk+zgqXVQGa1rgXnXA8BlD644g6
   O0HBNaK9ufzDDP/H8xKYZiH2WG9VWwtlWmGX1Lryfy6kCVQtdld1ze/1XMQddXntq78ex88idUAc
   2NeZS+UYiOO4+sX3vxfcuDzg1IdPvfjVrl7bsdc69AsOojCL15iWjGmY5vzP8sETT9B8I4hfik+p
   C+pL9138aqTSEB0b7ptlJWFL5Q0R0b5DgAelgwjyZRKSH4VIMQ1BuSavxYHELNsXVf7OUd2CxEnL
   7C6RphmY6bKlWdyt5Zv2WF1sPOxI+I2QVcep3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bbDvOgnNnW8MCpRis/mPktDEr89/opcmRz3rf27OXpQ=;
 b=QK3bWfF+0zik7MpsKDd/e2RBn/9oMiYQ9OCIULsH3JVz7jn3mmFAqV6mSI8dr2i0QxPUWhje01BX
   x8sfzQUfuHKURD75Avig9srHbSu7PKT7UKirJY0QV8bSh9zQsoF+aeSLXj+IusWuYmwr7qhv4z43
   DNve2QDdumJHq46wUnEPvT8M7+dVul5KldGUMGCglK6NqmClQ2nabeu6mg3HtpPXYzEj0uBd2AQK
   vQvg4hon8Spa3VD5kq+lJE8f+VDUi2BciwcCgT5dXH9jfvYM2u5DkrL0y3ib521/8mc2xjSklvsr
   i5KsDvxa7jRvKvwi4vA2F9IYx6XVDWucJYtYeA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRK00MH5B37II50@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 15 Mar 2023 12:37:55 +0000 (GMT)
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
References: <20230314140522.3266591-1-yi.zhang@huaweicloud.com>
 <20230314140522.3266591-2-yi.zhang@huaweicloud.com>
 <20230315094826.okdarxaapjyqmlhq@quack3>
Message-id: <8c4ff3ab-4af2-58ed-4d08-3050c044f445@huawei.com>
Date: Wed, 15 Mar 2023 20:37:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-version: 1.0
In-reply-to: <20230315094826.okdarxaapjyqmlhq@quack3>
Content-language: en-US
X-Originating-IP: [10.174.176.34]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10649
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=205 mlxscore=0 malwarescore=0 clxscore=118 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=480
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150107 domainage_hfrom=8464
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, tytso@mit.edu,
 ocfs2-devel@oss.oracle.com, yukuai3@huawei.com
Subject: Re: [Ocfs2-devel] [PATCH v3 1/2] jbd2: continue to record log	between
 each mount
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
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: _6iyedk8nJKX1IESTNrO2cJXMjwmnC0b
X-Proofpoint-GUID: _6iyedk8nJKX1IESTNrO2cJXMjwmnC0b
Reporting-Meta:
 AAFGEuPfDlAT7i1QFP7dIj2RzykCoVMmuit6kapy5mXk2H2tHV6I1Dj7+geWBKac
 aFj/wPiPQDXGPwZHTIasEpsDQ4D8SezSPIoQLKPFL+WMtjE9VHq8f7iUEmWqsrYU
 M2WeZfUrP3svp2LFvcFzdwX55tvLhuiqwkFECl49BDs5d2ZIpuZ2rHpTzgBP73o8
 sB/Ohs5w1K+023303qjmO859IB7TG1ZvLX1CU/OFsfkoGnhG2gGD6W7f9Z49l8Qq
 CdKUOgpMgh7UNVj91Lv/zoYqvWCBDspKttedcMcepye00DD37v6p14qLmzot58b+
 f+0nTAPuaTbUrOE1iH714Ji1in4b6J//aeNqS9OheCRmXsYuqB6x3V/qgtrbhCfD
 HlWHLI0bwCrbZgoSA1orX2kXtm99KWGnnBsSdhoH5qlv/l2U7Dhm2jNNZ1p5xJks
 XadivkwIgztYzwbH7jkX1xUd9kq8IdFOs5XdnFaUpxgLc+MEw2XLlvpLEutrI1pe
 heeh2Rp5xRT0tgd0qf/K1OwdiQtc0Ms//9Asp2DMzTA=

On 2023/3/15 17:48, Jan Kara wrote:
> On Tue 14-03-23 22:05:21, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> For a newly mounted file system, the journal committing thread always
>> record new transactions from the start of the journal area, no matter
>> whether the journal was clean or just has been recovered. So the logdump
>> code in debugfs cannot dump continuous logs between each mount, it is
>> disadvantageous to analysis corrupted file system image and locate the
>> file system inconsistency bugs.
>>
>> If we get a corrupted file system in the running products and want to
>> find out what has happened, besides lookup the system log, one effective
>> way is to backtrack the journal log. But we may not always run e2fsck
>> before each mount and the default fsck -a mode also cannot always
>> checkout all inconsistencies, so it could left over some inconsistencies
>> into the next mount until we detect it. Finally, transactions in the
>> journal may probably discontinuous and some relatively new transactions
>> has been covered, it becomes hard to analyse. If we could record
>> transactions continuously between each mount, we could acquire more
>> useful info from the journal. Like this:
>>
>>  |Previous mount checkpointed/recovered logs|Current mount logs         |
>>  |{------}{---}{--------} ... {------}| ... |{======}{========}...000000|
>>
>> And yes the journal area is limited and cannot record everything, the
>> problematic transaction may also be covered even if we do this, but
>> this is still useful for fuzzy tests and short-running products.
>>
>> This patch save the head blocknr in the superblock after flushing the
>> journal or unmounting the file system, let the next mount could continue
>> to record new transaction behind it. This change is backward compatible
>> because the old kernel does not care about the head blocknr of the
>> journal. It is also fine if we mount a clean old image without valid
>> head blocknr, we fail back to set it to s_first just like before.
>> Finally, for the case of mount an unclean file system, we could also get
>> the journal head easily after scanning/replaying the journal, it will
>> continue to record new transaction after the recovered transactions.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> I like this implementation! I even think we could perhaps make ext4 always
> behave this way to not increase size of the test matrix. Or do you see any
> downside to this option?
> 

Thanks for your suggestion. Indeed, I don't find any side effect on this
option both in theory and in the actual use tests on ext4, I added a new
option was just from the safe point of view and let user could disable it if
they don't want it. I also prefer to make ext4 always behave this way.:)

I would like to keep the JBD2_CYCLE_RECORD flag(ocfs2 also use jbd2, I don't
want to disturb it until it needs), remove EXT4_MOUNT2_JOURNAL_CYCLE_RECORD
and always set JBD2_CYCLE_RECORD on ext4 in patch 2 in the next iteration.

Thanks,
Yi.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
