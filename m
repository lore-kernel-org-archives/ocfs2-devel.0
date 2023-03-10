Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAEDC6FA99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 03:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T3vUXw4fhU0Yfn+x3eLXJwQ1dqN9AqKGYtmfpbkwd+Y=;
 b=0i8KUzGDlskXdRZV6dK8Eszvc/2WgMpjRDcA2rF801pfneWOdCyTik9QvxqF7IB7Bbh3x4KnFK9x
   6ad31Ho0e2HcGEC80zc2NQnEudPc+Rr8J56blfmdE8h1Rw+K2pyl6DkO4LuCcnuxYDg+nOKLD15U
   nSf8f/leYnXQ12oEUXLRxo2CBY3CMWvXOkS5HE+r8lw8chfgxv19ZDgM0GeZcGMQ66WFtQfTKOzm
   7Y7mFduY04viJCWOV65DRq+4ren1LnA7l1/z1NfZS0AKJqVDh95KDgU/Z34mIKDNtMfw6CjQldec
   K8SCUqX7FiCZE5EE3VFUdGsbhUpaqC86oefmMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T3vUXw4fhU0Yfn+x3eLXJwQ1dqN9AqKGYtmfpbkwd+Y=;
 b=Ju0el3ozDdgyo/BOdGw4vEZ2DQ+zkOnUE+PYITY5QAylhvLPmpyARXjj1YGJlW3SMEHay0gqUcPx
   ATe9hqzrha9lw8ShBOm0rsMheWBXizLS7JCSphXgv1TW+s2Ev0gc8uJcGJZrr79F1Hb411tRP0lr
   Qx0m9EK+8pOQlpro9culRfqKFLVwCBCjp9oLrJfHDAYeJW1Iiw/Wxpgalnb1OTOxPhqn6GzqGArg
   8ONasC2hn3ABOgvwaSebQMpXtnIOTWikMLpY4VAMoen2PYqXnobnwO0Njs+5wAbtROgaubaae59F
   WXH7nxNyZRWbb/GSJZF3JR4wQ246pz5dQgtwGw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA003B2DICHQ20@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 03:54:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=V8JJBoZHl/XeAI1qBF9glR/e9T3zmJcaDJfb/kXaH98=; b=D4ry11yUWAUH1oMXQ5hZe2j3jw
 b0nqPMu2bcR5UXsMiI0XHH+52qHhw+yb7ccP+ge6oxH5WsMAsgspWyhizzxyW9ttNSzIBUFbZhjuk
 Z+PcCG48HYhH0g4D2apq8+L3zPr3AJslSNKUQ90pfcfOXTLXZKCRPe3ARn2xYwV56QUEyd/gZKhQT
 3BHnEhVL2gUdS1XYnoR8jM/Tm1vu3lH2Z7qo2mxgbp0wVEw0Uk+LlW+TIjFq/oqLfGl2s223XdZoG
 wpvRHzcSeJ6axSlPj6So/9jdQzKNk9C+leHSt1LVO/WpUPjbUobSZguga31cNHF4fdWSLl0r48K28
 CXq2ay5A==;
Date: Fri, 10 Mar 2023 03:53:53 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230310035353.GM3390869@ZenIV>
References: <20230307143125.27778-1-hch@lst.de>
 <20230307143125.27778-2-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230307143125.27778-2-hch@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=156
 mlxlogscore=445 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=216
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100028
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ufs: don't flush page immediately for
 DIRSYNC directories
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 3773fxLuFLmZUFIdNeT8U_vEZ4VNOszV
X-Proofpoint-GUID: 3773fxLuFLmZUFIdNeT8U_vEZ4VNOszV
Reporting-Meta:
 AAFQ33ORoE37IzOxb+kxlkvlqDCHpFUwTHhV/6eZuFQCmrSQC6PPZ6Q67tc61AZB
 xC8BNAHekStZC04odlHzmXp70VNVP4JTgqYpmSmJh3xG9gdN5jG99jOOpGlsGCG2
 YcunrxJTsRIKeUPFaKtgKCJwymRfDTjfY92phqGkOMUMqsGjo3pYeE/3aRT9Tcm5
 qDgw1J/hlA9LkC2t/PgOCpBnP7fkpJy6gq6fSYHYzBaYU29uw/0qDLpIwGeqzAf8
 5+vZPmz3r0zPHa3+hVoxRHvYMHuHRXgfv0phFjVIOfKhDgJPv071hgVmKshaDpl8
 amR6iaD4H+tOPcu0pOmOsZ4/4/1nj0wdMsoxFXCIaOxF319jlmZx9jeFudljOlBG
 m/g46K9ONfMVbiGUqIUtlD3d/mKwJpo1adNBhjx+IcncNCXU7pv7XGO3GTOsFnVr
 4hq3+keEKyl2ZrYDxn3Mol7OVKYCWNgNQsTUEG+I2wiLabkCsT91eNWYzhi0EuDQ
 a9FXubZ5W4anscrcWQA7CwRAR9LVj+IurpSomZ+vVOXQ

On Tue, Mar 07, 2023 at 03:31:23PM +0100, Christoph Hellwig wrote:
> We do not need to writeout modified directory blocks immediately when
> modifying them while the page is locked. It is enough to do the flush
> somewhat later which has the added benefit that inode times can be
> flushed as well. It also allows us to stop depending on
> write_one_page() function.
> 
> Ported from an ext2 patch by Jan Kara.

Umm...  I'll throw it in ufs pile, I guess (tomorrow - I'll need to
sort out Fabio's patches in the area as well; IIRC, the latest
had been in late December).

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
