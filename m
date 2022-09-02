Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 029AEECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Fri,  2 Sep 2022 01:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mvUpsnHknUy/voVnY/YnMKzL6h/Z9A1BlpzgVIFzYYU=;
 b=dUo+0VDRogMwKbParZhaCG3JgZNuqUxztJcoFa4N3lb9Bgeq+9a3eUgb4P+OiVrVTgSPvHeGdHpB
   W4PvA6mk5RiTRA56WqUDhWLVl5sc+daKyfHpTdbTawKEmrsOyT34vZAZ8yh1F4quTaH22RkLzf24
   sm6pKgxWFOcdENYwg+s+r+K6AZauOS++Z3m47ueS0+odF7z4rL1DUILejGYT4ZO+pT+5sXYVB2bK
   z1hAwtzNTd3/NXnzET9Qo0F8cJ9fQAs7rBe/gEdT0XvxTaxmPfks9hvigadtL2bcJFptxxjUtsFn
   BQsPbaKK9ckO19vZVv55AcivESCfdPW1cHamaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mvUpsnHknUy/voVnY/YnMKzL6h/Z9A1BlpzgVIFzYYU=;
 b=cqEsvaifSs5/GuoKT14JlmXiBB/CWW4Ty7B3qezmuFC14jEGx5kx+LtMRIRJWoTTG4VPaqCPPhz2
   bqTW3YXKsLTKgxBOiDydxsLGbKfjIKqd9PYVi/Zw5B7bXg3eR5Mx2vB1wJxWz8Pxi6D+66PZIDYB
   4HP/q42GeYeUNvI41pzzC6vSMxXO+fLVzKGaL3KgMPI7h7ap9b1yaAApTea4c1/a3P0fBjwk7L4c
   8uJNr3t6K4LIRsy2t6K/xMsuykPXHwUWxX+YNMyrOHlxtk8ijfP4xOAiZRYB9tFivU4ZUSQVdMvN
   U6z17EzBFFP/XUHFIGqfLLtbTVLwR2pR0k0RTQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHK005EW6ZC35A0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 02 Sep 2022 01:33:12 +0000 (GMT)
To: Al Viro <viro@zeniv.linux.org.uk>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-14-yi.zhang@huawei.com> <YxFOqimAyJNxuPM9@ZenIV>
Message-id: <3fdab5fd-1efa-9668-da5c-889e9bfa1524@huawei.com>
Date: Fri, 2 Sep 2022 09:32:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-version: 1.0
In-reply-to: <YxFOqimAyJNxuPM9@ZenIV>
Content-language: en-US
X-Originating-IP: [10.174.178.134]
X-Source-IP: 45.249.212.189
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=173 suspectscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 clxscore=89 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=753 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209020005
 domainage_hfrom=8270
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
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga03-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: LKv9ClZAhqzyKzme-wHvTXit-zIz5KWm
X-Proofpoint-ORIG-GUID: LKv9ClZAhqzyKzme-wHvTXit-zIz5KWm
Reporting-Meta:
 AAErGDA3O1D/SObsFaG29ZwMJBwi53DZJAAAOySRwExu/VXzX/Vx2O5qBlrx63Ef
 TD7mrT9LUL7gXZiARek872IVSSBLDsyHA7ee3cEmUFm+b5+aSqm4MYTXkfUk45mI
 Pbzpw73ZDcd6H3nGaQTr2tIJl7To+ycKoK+YUGwGJwKX2nsq6N/+BxUHHqfcAs2L
 Fwllcvz6IxbELwpyjrheH9X0KenVkBTHkIGDIc4u9Yy+oA0HIXQLUFl97SUhEDOQ
 PUkv0Wy/k+ShKTsuDrKHpEghGNpK/5ZugOlz5O4v8yTteVDc+f4vtbe/2Y0t3u5j
 qJlxZqJAgWNDE/Ybl2h0MWlvoxx+Zbtoj3mwlKHqr421TSSDaxA5IYj7SoE7u2up
 iotawGnEvujOBS0ColsJ64oI/ZuJnS/ILLWBcQxuzzfyyzIDoNlgrCCXY0yV1GCx
 eZrYBBCNFIfjYpoHb+/R9/bUlxBOkh7utMZwHWWzbuHLrtG0kM/w3HqAgE0YBITt
 bvZJgC0rLxWecex3oEtWhcYmbjyeWcEhWERmmxnLzY+A

On 2022/9/2 8:30, Al Viro wrote:
> On Thu, Sep 01, 2022 at 09:35:04PM +0800, Zhang Yi wrote:
>> bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
>> has been integrated in bh_read() helper, so switch to use it directly.
> 
> s/bh_read_locked/bh_read/ in the summary?
> 

Sorry, I don't get your question, I have already replace bh_read_locked()
with bh_read() in the commit message, there is no bh_read_locked in the whole
patch. Am I missing something?

Thanks,
Yi.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
