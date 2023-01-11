Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08C9C46467
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oxEDzLOu/yj6rbM9H7zcnRsyU2Qt8mrUkCD0wgAJSzQ=;
 b=hc/rtryDv3USzv6y+yuTZeG0rb3SLFcnNEe7BX/NGbEBOHezkEXYyrC9ua4mcZr8xX0hIN5Acdng
   QZwU0Tjb6bd04NyyuF7KQmGpsjgQNEm2aTQs5rjnVk7EK6mvea26l9vN3o0I+stsaJtWaO6cADHB
   3jpGT4Ilg2JAVf7CdXGgQxaRKO3TyNQzXGE6Wecw9+Dr+ntnuHbxW/7hNfJlkZyrM32E2ZPmat55
   Ax64nTa6p0Cc9495mnx9w5velJhW0bcDXLIT9Ea0gVGvNpddXdgjjDeJL9IubXqcwrRMAkj9N0qo
   4pKTbhyyr/QHcUtjjoDEZ0Kc7MgppHIl7aEuaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oxEDzLOu/yj6rbM9H7zcnRsyU2Qt8mrUkCD0wgAJSzQ=;
 b=pf8DQvD5GEH+YtlHSZw+shpiHxNqjODogN96Rgs13z7Wq6nK80XvQP4eiRYQiPul4F8TINLlqA6H
   5kVJDZKTX3OHaNtZCYdgHat1BNLK2jJXtDjopkULXqOsPjsF3GiRJZ5lDQ0PcSz+q91GjRKihE2w
   8hapv42RDVOy6lgdgJVHF253OVTE8wl/1QOgblFc3Mu5cRZPnRUMT7rhIIthcabD/+P5Y1EIyCJN
   bfrGaSVq5CfYNCD6ygkHoqtkQCvrxQKNXTrzyLw8Lu/1GKT7ndeI7jTBlUd5PPIlMUSFVXD5DQxD
   jjQAvvggFHcpTZAMT7qEyBLneXRuHL38l+4Q2A==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROC008MZ6007560@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 19:26:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1673465163;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mH835/H7CJjALAQQPrPqSv0tI1NycZjQjwAi6V6jrQg=;
 b=So/feScP72zUN1fl3YW78TZTSzlscDVER24BUidbmXOEX80wKMypgMljBtOtzwzsxMlto7
 8YGw6FsPjwfy2lWXnjc8J4JhFlUJXYW9JIxWYfLX2uNqFqvMVz+B7ikRliOR8+ri31fmKY
 a3LS2GgNgzC5dCaHlrWC6KwjhuZySXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1673465163;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mH835/H7CJjALAQQPrPqSv0tI1NycZjQjwAi6V6jrQg=;
 b=HWvXjIxByWtXQqx8A0QzVBC60YOCI9T/3yVFWUD0X353TG+gV8+WGddh/ubAILvXHIigXN
 WSNivWu4qsF+bkBw==
Date: Wed, 11 Jan 2023 20:20:27 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230111192027.GJ11562@twin.jikos.cz>
References: <20230108165645.381077-1-hch@lst.de>
 <20230109195309.GU11562@twin.jikos.cz> <20230110081653.GA11947@lst.de>
 <20230110130042.GA11562@suse.cz> <20230110153216.GA10159@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230110153216.GA10159@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10587
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=848 spamscore=0 clxscore=185 phishscore=0
 priorityscore=266 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110142
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, David Sterba <dsterba@suse.cz>,
 Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org,
 Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
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
From: David Sterba via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: dsterba@suse.cz
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: qfjq53Ipec3Iocz655KqV7eV6XeCD1oE
X-Proofpoint-ORIG-GUID: qfjq53Ipec3Iocz655KqV7eV6XeCD1oE
Reporting-Meta:
 AAEhb7EkxET93LxhYDigSmjZSioGArOcOcU/JBONJgPbOQPDoWGh4JwBFG6fuNWZ
 wYS09+wlBosQBLxvAcL3XUhpdmdNEA5KKMOG+i9/FZrt5cEqbXIb0INN4cNnh474
 vZdFqBRbbGKB8xZGEd51VIuMQN6YSj9j3NbU66bZIl7/RE5LflkZYIoTw+jOwTxx
 j6OC/Vq1U+vM4RLVZKyHKXSl4vnYZ6SwbTp+kaFSSP8Pu+EFOjCh5dXtugcN5CN4
 EtuRbd6hN0eqWv81JoVWfFmseC9zxx2fc+Eqbwf02Iu/kLNP8r+a/Od6Rrqy46Ar
 iO9bEXPzpZuxqFWbQbx2ihjVaY3xN0KOCoR5ps5Vj6WC8qQvbydqkBXme5jWlL7y
 2zgLH26GkpkwU1YBKHcB/9R+It7Zp43cVB7fYQZ67Wj+dxCSZJIWq1m8WgEIzL4P
 nMlJwjo8hsuxX2zq2Q0IV/4bmNy0XbYwenwK7XTtZa/VMnkJABIbXqZYW14fnKyM
 YoxRWifzwaI5j/uY0SSiTQ56ERZZ2AYMlZHqz54t6Lgb

On Tue, Jan 10, 2023 at 04:32:16PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 10, 2023 at 02:00:42PM +0100, David Sterba wrote:
> > On Tue, Jan 10, 2023 at 09:16:53AM +0100, Christoph Hellwig wrote:
> > > On Mon, Jan 09, 2023 at 08:53:09PM +0100, David Sterba wrote:
> > > > The btrfs patches were sent separately some time ago, now merged to
> > > > misc-next with updated changelogs and with the suggested switch to folio
> > > > API in the 2nd patch.
> > > 
> > > Yes, 7 weeks ago to be exact.  I wish we could just feed everything
> > > together now that we've missed the previous merge window, as that
> > > makes patch juggling for Andrew and Matthew a lot simpler.
> > 
> > The patches are not fixes so they should wait for the next merge window.
> 
> Agreed.  But it would be a lot simpler if we could queue them up in
> -mm with the other patches now that we've missed the previous merge
> window.

Ok then, to make it easier for the folio changes I'll send the two btrfs
patches next week. As the rest of the series does not depend on it,
I don't see the need to let them all go via the mm tree.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
