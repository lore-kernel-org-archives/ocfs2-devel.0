Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D52C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 05:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6hyAr1adtATRvyqLh3Ss/FtkR1NYRRR0Esayx9gLCVU=;
 b=rVl09zmNjEQ5x2ha2r24ZPcKzzjw7oz/S2e16HO4oW2+ZHps7IbabtttuKWzkaznwLKHWw2LMM5A
   NheF8F/ojdXYxy9ZZ3PaffA9FOXSlCvD5/G9ksM15TNuc6EfbAfCf83rx47VyHnOisbavrsi+j15
   33Vylr70y/h+2RHakSgizsNkZIfRhkaw1AClTzfR+3a7qMS6dHpOAxka4xYAzaf6UubWiZpQXrn6
   Z1lltVtRmA7AtlTU6IprZZZLCAxaqgh1Fc80wGcuZhOLprlZL1qfowkpqiUnX0lJlPdUAfREGtdP
   4Duwsrtl4p3m9Z4pkEheG6CjOOO7Bxf83Sc8+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6hyAr1adtATRvyqLh3Ss/FtkR1NYRRR0Esayx9gLCVU=;
 b=Ff++dJwnA4OrwS5Wd2E0ZyB3JPzRfUd7M0fG0VzKbgTPEVQK1dVkfEFlysg0LhusElmJR4JJ8ZvH
   /fWRZsqZxkS/RyoTgnP3KEYnG4F+fvVKN6G25dFJ6l7LwzV9u4tecQBCmi3kxAWSlQPjHGns7QIf
   39F10k9fDqYHIoH3ol+WTzcODxXYU4UvC0YFSNox7nx/w3mNYj94HoyT797OzH7WwGAw9qu+gOET
   iGBCzc4KPfYqOIgESmPkGc/hyrc8ltTNtaKeJ4M3bCTLzVjNKDrxxmDiwWLmXkbAUMSlEVCqEYYZ
   j84dE+AZ45zaMgH7faCTZO+QmWoE1eJRDXVEvw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK300D9Q8Y36O40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 05:37:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666330619; bh=C4x6hYFDAWi4DXcimrF67aLQPsZW93Mx96V0amCnWn8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=QlbKpgGx1qrMgSdaJyivXXf5qor/X961lpc0yRR+woSzH3tCcgiu1gmz/NBYEXQfe
 K4vsmjcCVpegODndBu2vg9R9eT4zstEkXIb1SfoFeTNCPoQOhnVD+4siGARAhiytQw
 tUVK0o7ipMo473nLX2GyW5d8TYlaC0oYKW+aMHhw=
Date: Fri, 21 Oct 2022 07:37:48 +0200
To: Luben Tuikov <luben.tuikov@amd.com>
Message-id: <Y1IwLOUGayjT9p6d@kroah.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 priorityscore=272 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 clxscore=164 mlxlogscore=771 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210032
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org,
 Yang Yingliang <yangyingliang@huawei.com>, hsiangkao@linux.alibaba.com,
 somlo@cmu.edu, chao@kernel.org, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 alexander.deucher@amd.com, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 00/11] fix memory leak while	kset_register()
 fails
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
From: Greg KH via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg KH <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: AhNpG6bHlRPThzADTZR314P30Laj17iM
X-Proofpoint-GUID: AhNpG6bHlRPThzADTZR314P30Laj17iM
Reporting-Meta:
 AAEEFqEROhsUH2JFQKSN1lyoWoc1mjN1+JrayHs6vPvFtQW3VIjDfy2nG29Q43FZ
 ApE/1d6sPbFFX12sEplsP7ES8rdPgFrdMWEB37nCs0oTb6qdRG7eBHZbipgjlvDe
 b2cICp84yp8RIb4+H+251CXx3ifMr66/yUVGM1jgsDs1O5HiRERCY4YLqFMB3nKF
 omPX8i9bxG5U2SYJlbWiSIxfgLvqJmEMfnbE9By1P4XPtnQJTNDkiqkmxEr6KLOV
 q7rjH0kJsJQ6g60liQl+Wpp5LG0MXRY8vYA+lNPLlyQWAoBCDWjnrlW49KQwwQGa
 GH2YJhZUhoXbJDfmUM+5DpXLz1E81dN1aI++j0mHxptn10kBAc0QiL0LN07asILy
 OqQw4HELBkaFVOpcBBl1qoxV4i+7xZWf9I/H6qimBrozd8r7ZLqOJorfjQMI4ylD
 jOnTRkkU4/9Qw0Sc/P0BKJ9r5oiMfTfKiEuD4+QC3yMVvdGiNmKCIaDdmxkdeoYO
 dwqyhJf5FmRnZ5C7brMqoqcxK2WOn8KFiqInQZAi7dh8

On Fri, Oct 21, 2022 at 01:29:31AM -0400, Luben Tuikov wrote:
> On 2022-10-20 22:20, Yang Yingliang wrote:
> > The previous discussion link:
> > https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@huawei.com/T/
> 
> The very first discussion on this was here:
> 
> https://www.spinics.net/lists/dri-devel/msg368077.html
> 
> Please use this link, and not the that one up there you which quoted above,
> and whose commit description is taken verbatim from the this link.
> 
> > 
> > kset_register() is currently used in some places without calling
> > kset_put() in error path, because the callers think it should be
> > kset internal thing to do, but the driver core can not know what
> > caller doing with that memory at times. The memory could be freed
> > both in kset_put() and error path of caller, if it is called in
> > kset_register().
> 
> As I explained in the link above, the reason there's
> a memory leak is that one cannot call kset_register() without
> the kset->kobj.name being set--kobj_add_internal() returns -EINVAL,
> in this case, i.e. kset_register() fails with -EINVAL.
> 
> Thus, the most common usage is something like this:
> 
> 	kobj_set_name(&kset->kobj, format, ...);
> 	kset->kobj.kset = parent_kset;
> 	kset->kobj.ktype = ktype;
> 	res = kset_register(kset);
> 
> So, what is being leaked, is the memory allocated in kobj_set_name(),
> by the common idiom shown above. This needs to be mentioned in
> the documentation, at least, in case, in the future this is absolved
> in kset_register() redesign, etc.

Based on this, can kset_register() just clean up from itself when an
error happens?  Ideally that would be the case, as the odds of a kset
being embedded in a larger structure is probably slim, but we would have
to search the tree to make sure.

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
