Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C51AAC64EC4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 22:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JGNQcomC/3aS2y3qBhD/6FBSuu8auQSr3JdbXFc2U2I=;
 b=aaUcxKsytdkmVvJv7BmxfIwB2HHnKOBrLXQJIMehONcmZK3Rjzxn3FVpd1HYJ06dAd8XU79F58tE
   L0GnrBxe8aJBckMzrioXOMC5yejG5eFqk7x9Yty/QsqV1mcCp16UrMl3WTI0OiujSf/Csv8c7/q0
   QFL1eOP4LwrPEu7RE4XAsAfqMbonFWeOoEoZ4QbwFU38s/tvnsZ0jmu5XGn9d5rKURjNMLGQUI9c
   xQYHAiPbxxBsp3c5IJ8gK1tIk5Nx2UsIBH1WoyQcSjyogde4Herimprgqep+LiDSORa1ceAOa77k
   BJUOsrGkdViK6BU7cqo+M+fWVklZOga7lz+wgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JGNQcomC/3aS2y3qBhD/6FBSuu8auQSr3JdbXFc2U2I=;
 b=EIwlQciaTfqhoFVdOq4OOGJp/pGEUyNOV5F1X7N1ZbCA/gKseAEEaW9FgekVxR3d8UUE0fJxR10E
   +orLRfZIp+13fsq/S9c5meFYSqTFMxRgGmfRJpxbX/Wv03neGcnd205MBpAecit1n1WaIVFHLPTI
   bimdDZmVLgFgiqMJHthlZn4WqbFZ2MTmZwH7H2O5P3ZS6czEnUvxKHeVXYnGtg0SZpyy/ekjG28t
   L6m2svXqVhg17kYzRbWcWu+UwOT8H2eJBPlUBhyJWaLG2Q6dFb5WCE90V9ZV4L/0XmnlrloiKj/R
   v3fXNN5VayWi9YyDITp9mvc0ipuc1H32rCmJ5Q==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR4007IDFAYVQC0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 22:47:22 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=valentin-vidic.from.hr;
 s=2020; t=1678142818; bh=OOKeFqakFI5OR8Vd7tJbkBi8CYu4+5URsS/JxLgJBbs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=F5Qi7azRHg7W2fKwwS8k9EfRlxweJB96igpwDO22mfc6zUDYFgurAKvm4r+HguksN
 bo4fxfxtds8U5uMR66f7xFMD7Hss3I/V++9s9hAmPfsG0YZuOAUolWUxWIzDNFlQ2x
 97LPYIaVUe8n6bW1iiQ8JEtp3x9CnmhIsibBD0Y1UJnI0eKa955FG1eNHLm5E/35A0
 ehn/sLSNdAbscJKR6Df1mXyau09vkszZF40blVfOzIjiJcJEu1nyBHaS315jatF//i
 Jed4E3fiE7wzMlS5NOyamqEZUFZmyKHa/SlTb/oPC8zYqjhPSxbXnRAzVNf5ynkf6E
 PvhFloaLIlxyyswNAmNOyc+HkDDfRbzpOAFik/Gpx32oLbpeWoAu+Hnjw6bOVTxBso
 /gjKhGL/7QwNeHX//nU9R2dcmxVaKGRgU+dXMeXyOCNzoZcDJcPCdqX7hrJg68EUXt
 sTeisEaTrb8/0nBTj+P+IQS3544T1KZB+VDq4adNhr6UEHR1E+sAlq88n9lLj2/ScI
 k0zF38qoL/+vlr4jyFs0nEU0dzM2W4m3L0yI5DoxjxRI2TQo0FUouNRu18Z1XUi9Bj
 rmaEfpkGmfti7iG5QTTWt5If2UFuDIJujXkYpXOLcb7lEYuQRjY9dsHhBewA84WMht
 YufUFTE4otbygtc/lPNmX1V8=
Date: Mon, 6 Mar 2023 23:46:58 +0100
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-id: <ZAZtYjHlhM6IAVpc@valentin-vidic.from.hr>
References: <ZASjOpsoM+nEx/o8@valentin-vidic.from.hr>
 <afce1ae289a52db2b210065a63a73fdcb7f3175e.camel@huaweicloud.com>
 <ZAXEVL8BZb96cxFX@valentin-vidic.from.hr>
 <e804e6881e96680107a4db3d4b81e5e898f5fbde.camel@huaweicloud.com>
 <ZAZd0yMvJTV/h/DM@valentin-vidic.from.hr>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <ZAZd0yMvJTV/h/DM@valentin-vidic.from.hr>
X-Source-IP: 169.150.239.92
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxscore=0 clxscore=99 mlxlogscore=304 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=0 unknownsenderscore=20 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303060198
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
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: LCKXwZa74bzZNHpFooCWrMQMsYusrDpb
X-Proofpoint-GUID: LCKXwZa74bzZNHpFooCWrMQMsYusrDpb
Reporting-Meta:
 AAFzcmk+Lv6+XVdNWbNwseBzLoi1H4FhDvkHlsUY1qfkhS3xJ66ghnZcWsLFDyFz
 Kj+nyNfWNcdBB0uGLX65Z9vQ3SJgvQkDy5Ro7e33uyBjDbDRhKAPmyu2XDrg1TMi
 2lcBRocqFj1Rddvl2XdkkYcW+O0VOkaFeSt1OrOBz/wcyVqDe+Ju+Plm2DF/bx0Z
 hkHrP2Z/04CvcnqIer5O00RAOwbAVXQ5HrTCNRT+TW0Vtq1Tec9Adyvtt5yy6wlQ
 sjTz4+xxMQTciy6DPm0nPvgtTdmIaAwk9PZFthx6Km1iyhG7/tq+s4FfNbcc7Es8
 Uv1nWGCLpmMvj5CeVORNgpTaPOl3hDFuQKX9ph6y4gOCMa1xRg3x78A5etFVsAxf
 GPJMd6QcY+Z2Nv2ocW82HaokoqeINL2SDPIFoa8wbnieXq0oLhVk4uJeIJztMz27
 iHxiyK85EbDoQsAI5/fmI96D59X0WLGgG4o7zSv0g3IINr5rFskEiMdZ9xfMVAPt
 055gR9nYThvZHRmQCpSQkTF/zCekOaAw7X/wFKy1I3A=

T24gTW9uLCBNYXIgMDYsIDIwMjMgYXQgMTA6NDA6MzVQTSArMDEwMCwgVmFsZW50aW4gVmlkacSH
IHdyb3RlOgo+IEkgc3VwcG9zZSB0aGUgZml4IHdvdWxkIGJlIHRvIGNoYW5nZSB0aGUgZGVmYXVs
dCB2YWx1ZSB0byAtRU9QTk9UU1VQUD8KCkNvbmZpcm1lZCwgbmV3IGRlZmF1bHQgdmFsdWUgZml4
ZXMgdGhlIGNyYXNoLiBJdCBpcyBlc3NlbnRpYWx5IHRoZSBzYW1lCnByb2JsZW0gYXMgdGhpcyBv
bmUgaW4gY2VwaDoKCmh0dHBzOi8vZ2l0aHViLmNvbS90b3J2YWxkcy9saW51eC9jb21taXQvN2Y1
MDU2YjllN2I3MTE0OWJmMTEwNzNmMDBhNTdmYTFhYzI5MjFhOQoKSSdsbCB0cnkgdG8gcHJlcGFy
ZSBhIHBhdGNoLi4uCgotLSAKVmFsZW50aW4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBv
c3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2Nm
czItZGV2ZWw=
