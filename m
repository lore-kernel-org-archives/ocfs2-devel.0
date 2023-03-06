Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1DDAC678D4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 10:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/KKNItihDk/EA8YYVQyVuwKNwn9XH2rlIjchh0GDrvY=;
 b=HDi0u+u00wpmr1cja7U3BTgdsPOEGfu2CzzCsLCzPIQmAk2W+/znfSe5/OCnivyQkGvbK5QfdZui
   NfISOhlLd1H4k8OGXCHGbpI93/nuTxLt5QpFwJTkzbwGiHvF7KxEqIF1d1f9sXlgpY4YWmgLEiJH
   mYqyM1Bv41ezwgcNlIGGjtFxMhHs5YXbi+YozkcMrM0vGyV2NGi4jua8ndif6dSd/zS6EIJauiBz
   IVzPcXhG5j/1cXvfEH2vl/6eLDHNL4MsvT6a3gtogD2jqj9014xZk7l7LFktErs0RzKXedPZlzKR
   bPENMI/67FZorfJcKi9mf3C9HVhhc183AP5Pqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/KKNItihDk/EA8YYVQyVuwKNwn9XH2rlIjchh0GDrvY=;
 b=dPSXvMacbefqJ81ACZRJ1QS34dUFk5qKzr4Y71lANf1Vv3TrnuhS1uAHVL5Iri72d1QNzMqSI6WQ
   KpoYQHjDlTbVU0z7cnq9AcZCRGW6RnCXWba6nUALqG0dmZXIqoPgmpFDedS8I0tAlhE+ZtNobZkF
   PyYKrgMqOieLXvXax6VvBYRF9Ak2vFbUwQ0NbSNzldNxuVwuPvFD+01nX7Mz3XX7ogbBAlWBekvp
   deoRwoR98YpDByTBuzYrfCzymTT1gro03BeVyw2Gw0kxnjTLhFoTx8ZzguuFK53hn3RafU3V/7++
   3+eCpXevaNT3msXnyDJeZ5nF+kiHLgE8QGDNSA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR3008MHHX0BK40@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 10:46:12 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=valentin-vidic.from.hr;
 s=2020; t=1678099540; bh=TJSTTXprG60NmQmWyDZLC1fwGE6LsMFTxUQCSahKZP8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=GXynvx80X9ZjaEX9PZftPT6PplFx+YhEjpfd5VJTM2a0ekWcN4yiK7T63gO9AAbdH
 /06x80IpgUzF0fjtCiIfd0me7oHZv97epwJtjmf2moRfnZ21Lwhgqnh/9hDD4NOPtk
 GA6eSkNRjS7jhRbT1DyBvMlcnV6+I8STOJcoaebuglPTYZY4JNlqob1Z1r3xWWWB4f
 m6r5t3ziLjJSonkWDUlqicyrlGTY1zsobWvZmOwwoTIgkZfDLsuylMYVXkoBBmfGcQ
 ybTzmivYJZfFIGcglGDkQdfgwp9tdFRQnPByZoJ8buvTUjIBoasqmgAGi82CH6yZjb
 G4Uk/y3oBuTA3NmUAjDnRn2uVM4ZhWEtfuLs653t8BqbX1K+w387Rl9WTKNGZ2MBjj
 iwVd1TEkA77S5qzUXx5fdSoopitfIP2EfjOVtCnoZmeDn9QbVkeOMw6iJ1UkCJ7QoR
 6yfYPLbS0+GDz0bQc8WciXce+CeKAr2bxsOSZKqADYpIvaC9pZD+u8XrmcBl8iuOT0
 NB7VmAcX1EsCk5Fn++olM7E9Pg4z+5+L17edLMTMelVTazy40Uht0xMID+BdcxiE3m
 Hvx4zvjevPAtRpSWB0UMBDLzIugibKwbDRm5U6bTBn9MrpdyTA+zfVLjviR841NK3i
 /TFg0+Z+KUwYVA+ehZ83He+k=
Date: Mon, 6 Mar 2023 11:45:40 +0100
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-id: <ZAXEVL8BZb96cxFX@valentin-vidic.from.hr>
References: <ZASjOpsoM+nEx/o8@valentin-vidic.from.hr>
 <afce1ae289a52db2b210065a63a73fdcb7f3175e.camel@huaweicloud.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <afce1ae289a52db2b210065a63a73fdcb7f3175e.camel@huaweicloud.com>
X-Source-IP: 169.150.239.92
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10640
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=21
 impostorscore=0 mlxscore=0 priorityscore=0 phishscore=0 malwarescore=0
 bulkscore=0 unknownsenderscore=20 adultscore=0 spamscore=0 mlxlogscore=550
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303060093
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] ocfs2 xattr
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
From: Valentin =?utf-8?B?VmlkacSH?= via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Spam: Clean
X-Proofpoint-GUID: x3Bz_5fEF-7ZkMa0IAOgX-vaz7beXGor
X-Proofpoint-ORIG-GUID: x3Bz_5fEF-7ZkMa0IAOgX-vaz7beXGor
Reporting-Meta:
 AAELXLgrkPXpgMePYo/0G2u3br28boIOWAQohjL9cq+tEcWec9w33O3y+Ed5tFC4
 HbnU6WLIMk74C/FGcBx61N7sGG45mAzPA1MVeox3u+OUmiycU1Z72Y8z/Vjl4A5R
 9xIotoAB/iuU9BZC0a4l0yIjHgktPd6zS7ljxNqUiIxxJmxuhcjURc67q8/lz5OF
 fZsfTa4QcW2llGzGEAsIqgbwIr0K7Qir3+tkScBKpnUV+/aJoP1lok68ej6rCypq
 cDi6p2grbTqNezwcN73l4PnSjVoiPEwPH0+yg2cGp7lWvWnHh624AxRZZjCfv1Ha
 /lg+VgNL2ermesvuPctcsmsaF/6vYTYNQ5dmfJWJPtIxqDHZnZ2Za11HWqLU3Qik
 +csdfghtk0tKMZXjdmgFxjcoXcE40vkkMSYF8C4YRYmVLdEwHODIad9p4pEJ46Nu
 Gu/8o5rWonKNTZSkKJe8rUcET91KyCrfieNpHpt/r4aXW8xXI1XMUpesiKKdvUts
 MiqxrVuKl+pte/Gljn3750iy+MACTdWLw3Wz/NwPRJ2b

On Mon, Mar 06, 2023 at 10:13:45AM +0100, Roberto Sassu wrote:
> which LSMs are you running?

This is on Debian, so AppArmor is on by default. It seems like
only SELinux and SMACK have hooks for inode_init_security so
for other LSMs 'const char **name' would not get set?

-- 
Valentin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
