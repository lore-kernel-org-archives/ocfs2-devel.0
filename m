Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD05C54EBE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 Jan 2023 08:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2OhNiZvNZjvaM1aTHnQp2a35B8EchPcjHpyerwcOcHI=;
 b=t9Ki8vkCCb2JFPmwfYqCLFLk75mOEn7Oj3XZxsHOPzfRiDHgw2zaoXEi572xEr+waKclwI61SUnM
   rGsLy9MHB5gZ5GfTPcPEsA3TzH8sw88qOFWoLRPekotAozGPwMMKooj/egd3IsHPhTctPHsbVbTn
   qkBZziLT2LIbbMnP/pOocj18S8QGTapzI4r+pQTyUAB3UJeKkA5i6Pn1xd3lGN6eOuFQAHIP/UKs
   WKY79KNRmbMuFxXrnBCjekriBhRZuBanP41h8157TELYgTvFiTNIA9OXoKObO020qCXPplXqKcqg
   G/u2gBX3015CtljZ3oqYqZ2s//rd/ktUBUqBgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2OhNiZvNZjvaM1aTHnQp2a35B8EchPcjHpyerwcOcHI=;
 b=BBV3khxB8H5/LGRRl1YlqM9Z8R2XvxiKMhF8gxN3D3GZy9/BCy2FtJP9r0wgfkNsRY1h+UNe8jls
   RZeu5dOl2YA6yAlibrBPDUpvmiO9ZB32hZJMf6qnMPB0nJtTYCtM1ZIDN5Qk2Z7yepHUVUrKxvi8
   GA7I2IIPUy+6vu6lwrMYdWouARw5GxQX4dRSXMHV02WuvP12Vx6KqEJREtaEWaEUhrJO7t+6GHUJ
   ggXiSO22ugIcqEu1krxFF4sVxAZzZ7aZzy8HZ3lPbenjj7N2E6LQiFwnotb3OMQijGMT/ZZqSZaQ
   iNYNWvktyEu6xBpaOxRqbysLZVORRY0EulB1tA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO900N7VGJZFUC0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 Jan 2023 08:21:35 +0000 (GMT)
Date: Tue, 10 Jan 2023 09:16:53 +0100
To: David Sterba <dsterba@suse.cz>
Message-id: <20230110081653.GA11947@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
 <20230109195309.GU11562@twin.jikos.cz>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230109195309.GU11562@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=0
 mlxlogscore=826 impostorscore=0 malwarescore=0 clxscore=277 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100050
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] remove write_one_page / folio_write_one
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 61feFpePuAiiZHziyEn6pc6Io-Eh8fD_
X-Proofpoint-ORIG-GUID: 61feFpePuAiiZHziyEn6pc6Io-Eh8fD_
Reporting-Meta:
 AAENE9T3nhiHaGhfbTzEnhh+ggSQrnOa8Iif+93IHoQnYESQ61JRaf9p4JpgfsjI
 2hipsk+rFyvb9cmPLHZul0VUGy1B9PNsAOmqlzIn+uVb4BWuwQU/XyC2wxkXj+JH
 PgLnuOLDIH6xv3bLWN9lU/aFyLmXwMyF3fHD3oMpdMwbAif0wcPj3Qbp9gruM6EF
 wAZMgd2p8P75wPYJg1Fva/mFTijKM/o/SOf338vXvDxOOlnNcEaoDtrxtGTZqil+
 0jzNSoSGLZlCOsPuayGZEod+ttsIG3CL/r7g39fD0OkEvvPbg99cW3CQsxKni2CN
 ocItaSy7SswBMWEZh7BwsP0NHv0vAOc1J/nZqMoUaOCK7c+BwegY3ni1oR6qSw39
 N/FfIGHYdaPWrVS7e+O74hLF1NmLj2uBFS5L1qHL0skd8A9MH2nmhD7KYFgMz4Kj
 8M+JDNxX4CZaheG0umj1UytnW/6dYCnAJ/Q9AZNtAtcZuYtFQvvGYB4Ei7chYRcq
 llTIkQlghtTIKApxiY3AVcYZXJLkLADrdfLcbtKeqUk=

On Mon, Jan 09, 2023 at 08:53:09PM +0100, David Sterba wrote:
> The btrfs patches were sent separately some time ago, now merged to
> misc-next with updated changelogs and with the suggested switch to folio
> API in the 2nd patch.

Yes, 7 weeks ago to be exact.  I wish we could just feed everything
together now that we've missed the previous merge window, as that
makes patch juggling for Andrew and Matthew a lot simpler.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
