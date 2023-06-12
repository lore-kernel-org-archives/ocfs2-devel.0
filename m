Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEC9C7EE2E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Jun 2023 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=30XGCxl3W2jieA/ho0uj1qBkFEu+nzpS5llbY7aDBjI=;
 b=g2Rts+79K77PnOpntMA/8HEN090qp8WIAYkdq98rtSGjt9uKukExfKiDYO7vnUbNtEe9VAbGDRMo
   vxtnpxvl2mk/yxEmsjDCLGTgux7o24pQFj/oxiqbQGelaxJ7oTNygRJLhfkcwpoq6vwGe+IfaWI3
   Ve2Y1U9MqUZhWDtGC0ZUScFqbE5Z10CLpCUTJAd4FAk/ygNJTcCaKUjvdNOyes+WKBog/YHpDkxL
   cye91OcCNhxcQbnCZLOSkfO+1NfsYqYOI/7N4ALKCwTfDoJSyPwf1+YqMAs4mTQwou9Vx4tcbYBc
   Fngnkhl5W2lXpYPWMUWwcgwaO7ghi3xC5K9mcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=30XGCxl3W2jieA/ho0uj1qBkFEu+nzpS5llbY7aDBjI=;
 b=mtKWie7MdjmMyySZbPGu2ZhpbGkAJmVlBSODrq8eE6vNEYED6KXgZqAovcTY15BTYZfP8PD5udyX
   3sWqCxufxBMSMzEClS8hUax/EkONNSRaUTyh6dWEzI2/5sbocze5VH7vZNaxTObBXJ+rZPI2qQca
   LKW1E16tCUr/ySx0VEychlQ7o8E8g006FhrCcHKTQWveD+pMoZcGmoWFe7OWHvPuDxtrdAkU3grD
   KRJN69N8NpC5xwPPfTysJR3Lcppk9zLp3++KD4Vy05OOlog6833u45qPUzmRjBdPkSM3LdUuflsv
   0/l7ke7rPiWGRZ6uvNjP9CaiXib/AJLNtdoWeQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RW5009EVDTGO590@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 12 Jun 2023 16:00:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1686572761;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tTMhvLLlxLduku60kqh9t4hhU2KGCMkQO9qTJKYmDvE=;
 b=R8KYLgos4qvJwdjnlXTsKGUW664IAn57250CaNpFr6uEvwbf2cunOShycwBAh7j7Siiims
 cv2au+3tq5lIHiqG63ADTRcQd+W1dWLL03HtnHzkDgwi7/50ZOLB2qCPRKG7/7R2SAxAz6
 nqf0gzVkFdSSa6AN90x1L7SP2EXwEZo=
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd,
 Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE,
 United Kingdom. Registered in England and Wales under Company Registration No.
 3798903
In-reply-to: <202306121557.2d17019b-oliver.sang@intel.com>
References: <202306121557.2d17019b-oliver.sang@intel.com>
To: kernel test robot <oliver.sang@intel.com>
MIME-version: 1.0
Content-id: <105868.1686572748.1@warthog.procyon.org.uk>
Date: Mon, 12 Jun 2023 13:25:48 +0100
Message-id: <105869.1686572748@warthog.procyon.org.uk>
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10739
 signatures=596816
Cc: jfs-discussion@lists.sourceforge.net, David Hildenbrand <david@redhat.com>,
 feng.tang@intel.com, dhowells@redhat.com,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-mtd@lists.infradead.org, linux-afs@lists.infradead.org,
 linux-nilfs@vger.kernel.org, lkp@intel.com, cluster-devel@redhat.com,
 ying.huang@intel.com, linux-ext4@vger.kernel.org,
 John Hubbard <jhubbard@nvidia.com>, ecryptfs@vger.kernel.org,
 linux-um@lists.infradead.org, reiserfs-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, linux-ntfs-dev@lists.sourceforge.net,
 fengwei.yin@intel.com, ocfs2-devel@oss.oracle.com, oe-lkp@lists.linux.dev,
 ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
 linux-karma-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [linux-next:master] [splice] 2cb1e08985:
	stress-ng.sendfile.ops_per_sec 11.6% improvement
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
From: David Howells via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Howells <dhowells@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: AynBElupPJ6WiOJw2BAedg-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: qrAhWRn7NxANeUEn3CFvZwjhuNeQaiHX
X-Proofpoint-ORIG-GUID: qrAhWRn7NxANeUEn3CFvZwjhuNeQaiHX
X-Mailman-Approved-At: Mon, 12 Jun 2023 16:00:50 +0000
Reporting-Meta:
 AAFwsqQvZpO2sURzLaEXbWRilU7p4vtmVJY/qpGr+Llufg9cH5pm2p4hdjwpy6wV
 cph90c6nCHd9+NQtMgdb2dsCYi+q1R8rkh6gKaV0hVKOgI3RLWFGzJHLYUit5COl
 V2+uPPWZdXxlDarbAFtjG9Hkdj3KtWoOraHyUgFSUHfnQ88GYpQ4dXPHMsZAK4od
 kTGmbRv56TyE1OvJj/d+UaB8wpvVEoo4XND9NarkK9nZELLn6JUDobMk7ZCTFBTc
 Y3pl4A5lwlsN2hoO5nMMSNxg8xPx3oF+12MU81r8Maeq17zx8aQDzoAGTUAXXc+x
 h7Y0/dflE9Hus4Ic5goyseiDUWU5C0C4tMmkN1RrpbydmohmleU4IyoZOloIB1N3
 FFISZNKmur77Ys1vTSGMhWsQ8uaY8mQzT3sLpLIBzEYSW14C+6qmbTIwQ/3QDDu+
 Htki70oOjBiDxplj7v6vNf9q39uUl1KkZZ5eabMA3BPBhfdW5llMA5Pu904duVnh
 NuWaRKb12AYpZl6G0ikXPzNk8Ra97OB6Xz+VBPjhyGED

kernel test robot <oliver.sang@intel.com> wrote:

> kernel test robot noticed a 11.6% improvement of stress-ng.sendfile.ops_per_sec on:

If it's sending to a socket, this is entirely feasible.  The
splice_to_socket() function now sends multiple pages in one go to the network
protocol's sendmsg() method to process instead of using sendpage to send one
page at a time.

David


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
