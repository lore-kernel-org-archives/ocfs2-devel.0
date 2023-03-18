Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1A3C74A5B
	for <ocfs2-devel@archiver.kernel.org>; Sat, 18 Mar 2023 02:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jXGtaeczaJ2qBDoxfI31sz7srHUdli8vZCNOV0DaLUQ=;
 b=zziSs/4hZgAaV47lSuSXyXKQet72dulU4ZLgw7wgiaxBVQtNP/TcWt7FZ+ATdJpPLgRS3zMsukvB
   Ag+814TJiHjb5gjuYB7WEOYDMoJnlB+gT/7fIxaSXhbPaokfUowkBLjsWvS5/FvaaFWAijZFEJb3
   llEAgCWfWL4OJZByfUvolwedX7CLyzab6T4YXteIGjVeeCCDqlhGCcaPAdh+CsZDgszG3L+zrQ3p
   FW0oWTiOvm+k6slg/1fYsClf+Osj5pIUWARQNYyzyko0/yVdI36EWK8SEnO0zbWnJoPzh+x7x7N5
   5pJqsFYiufXWA+BG5MyiGs1KloOBvU2gKQgWhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jXGtaeczaJ2qBDoxfI31sz7srHUdli8vZCNOV0DaLUQ=;
 b=grmtf2SLOPAIuGQ2jq/VtdoBoZPG/W2meXBe2BsJAKoujbZRr/QYwKSntXwnoTh228r3pls8wQOy
   6Iuh6gkDCqVjIO+rmspND1HSwUof+uuoqdNlYyahFxYpNdehTlDCSm7QVsg99AL/DO2ixn2d0/HZ
   UnLghGL0yHleUjHh/3luhD61huF9HLWWzdkyOPFws52fvrEZOS9YP6njgfF7NF1XFbiCCuIwJnWN
   VM8eQV2QttKrd77eme/bVa41Ns2Ffbxqf4BzZsKSGoD49YMaqvSw/n8mJHjZQx5GzmgpzduxwqFa
   JT4vszbIMpcXSaP/9rMs5vSa/vG2D35JYOByHA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRP00M8W2QLMFA0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 18 Mar 2023 02:25:33 +0000 (GMT)
To: Jan Kara <jack@suse.cz>
References: <20230314140522.3266591-1-yi.zhang@huaweicloud.com>
 <20230314140522.3266591-2-yi.zhang@huaweicloud.com>
 <20230315094826.okdarxaapjyqmlhq@quack3>
 <8c4ff3ab-4af2-58ed-4d08-3050c044f445@huawei.com>
 <20230315172817.egezft3msc5z4omm@quack3>
 <20230317112528.cig7fczuoezn23wy@quack3>
Message-id: <6769d7eb-35bc-fbc1-0c15-a62309fbdb81@huawei.com>
Date: Sat, 18 Mar 2023 10:25:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-version: 1.0
In-reply-to: <20230317112528.cig7fczuoezn23wy@quack3>
Content-language: en-US
X-Originating-IP: [10.174.176.34]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10652
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 adultscore=0 clxscore=28
 malwarescore=0 phishscore=0 priorityscore=157 mlxscore=0 bulkscore=0
 mlxlogscore=463 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303180021 domainage_hfrom=8467
Cc: tytso@mit.edu, Zhang Yi <yi.zhang@huaweicloud.com>,
 adilger.kernel@dilger.ca, yukuai3@huawei.com, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
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
X-Proofpoint-ORIG-GUID: PRQpanWPbb8cq8K868RSQv8NxmOVu3wc
X-Proofpoint-GUID: PRQpanWPbb8cq8K868RSQv8NxmOVu3wc
Reporting-Meta:
 AAGjGJfTs3zBQQgTzqR33KDiLifPHk8/XC3d/CLNHveobHizQ8yuzV96IjPrJ5BO
 MWQg2ea3dqjchPXt/86WB5WSud89Ai5wrx9AyWLce+/OAXpSlHW5dYt2aXRIliaw
 Kn3XEzk60WbFk/BDCs7x4/se+U7hneSxoeo0uUkh1uFj+ZtCOnP1hjB3ytZL9U0U
 LkJajaRA7f2I6A/DHueyPNBscsFfmQLRR38vFfpB0SU7PXCqddWjAVY5ZB6RBNSh
 5FdZgBcMbmCWrOTYYwnV/Ulp07FoONRCVBZ8HwCO6LPuFND2Zfz/t7RsFkmgDdpW
 OwmZzdZibLrqobYOs1A767muHO5PQbCDa3nb9Ih7fD5qEHHQoZ6dFJkrlrbG2LAm
 VYA4YZKXIpeOrkqH4DQlM028rERxsWVeCaYIT/7n3vRnfqQjQEXvBPbPb/q4KAz0
 m7EVSE971KAFagQnVJbgDs2AyIVWwHA/+sA0Pn/QN9mv7hlENK8wmFE5cKCShjF7
 JAwiJgBo20rfjJnSH+VDdVBCyNuuUefgftF9iK4J6nw=

On 2023/3/17 19:25, Jan Kara wrote:
> On Wed 15-03-23 18:28:17, Jan Kara wrote:
>> On Wed 15-03-23 20:37:32, Zhang Yi wrote:
>>> On 2023/3/15 17:48, Jan Kara wrote:
>>>> On Tue 14-03-23 22:05:21, Zhang Yi wrote:
>>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>>
>>>>> For a newly mounted file system, the journal committing thread always
>>>>> record new transactions from the start of the journal area, no matter
>>>>> whether the journal was clean or just has been recovered. So the logdump
>>>>> code in debugfs cannot dump continuous logs between each mount, it is
>>>>> disadvantageous to analysis corrupted file system image and locate the
>>>>> file system inconsistency bugs.
>>>>>
>>>>> If we get a corrupted file system in the running products and want to
>>>>> find out what has happened, besides lookup the system log, one effective
>>>>> way is to backtrack the journal log. But we may not always run e2fsck
>>>>> before each mount and the default fsck -a mode also cannot always
>>>>> checkout all inconsistencies, so it could left over some inconsistencies
>>>>> into the next mount until we detect it. Finally, transactions in the
>>>>> journal may probably discontinuous and some relatively new transactions
>>>>> has been covered, it becomes hard to analyse. If we could record
>>>>> transactions continuously between each mount, we could acquire more
>>>>> useful info from the journal. Like this:
>>>>>
>>>>>  |Previous mount checkpointed/recovered logs|Current mount logs         |
>>>>>  |{------}{---}{--------} ... {------}| ... |{======}{========}...000000|
>>>>>
>>>>> And yes the journal area is limited and cannot record everything, the
>>>>> problematic transaction may also be covered even if we do this, but
>>>>> this is still useful for fuzzy tests and short-running products.
>>>>>
>>>>> This patch save the head blocknr in the superblock after flushing the
>>>>> journal or unmounting the file system, let the next mount could continue
>>>>> to record new transaction behind it. This change is backward compatible
>>>>> because the old kernel does not care about the head blocknr of the
>>>>> journal. It is also fine if we mount a clean old image without valid
>>>>> head blocknr, we fail back to set it to s_first just like before.
>>>>> Finally, for the case of mount an unclean file system, we could also get
>>>>> the journal head easily after scanning/replaying the journal, it will
>>>>> continue to record new transaction after the recovered transactions.
>>>>>
>>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> I like this implementation! I even think we could perhaps make ext4 always
>>>> behave this way to not increase size of the test matrix. Or do you see any
>>>> downside to this option?
>>>>
>>>
>>> Thanks for your suggestion. Indeed, I don't find any side effect on this
>>> option both in theory and in the actual use tests on ext4, I added a new
>>> option was just from the safe point of view and let user could disable it if
>>> they don't want it. I also prefer to make ext4 always behave this way.:)
>>>
>>> I would like to keep the JBD2_CYCLE_RECORD flag(ocfs2 also use jbd2, I don't
>>> want to disturb it until it needs), remove EXT4_MOUNT2_JOURNAL_CYCLE_RECORD
>>> and always set JBD2_CYCLE_RECORD on ext4 in patch 2 in the next iteration.
>>
>> Yes, that makes sense.
> 
> FWIW yesterday I'v spoken with Ted and he also agrees that we don't need
> ext4 mount option for this.
> 

Thanks! I've removed this mount option in v4.

Yi.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
