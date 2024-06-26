// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Poetic Form
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//    {_______      {____     {________{___ {______{__    {__        {________    {____     {_______    {__       {__    //
//    {__    {__  {__    {__  {__           {__    {__ {__   {__     {__        {__    {__  {__    {__  {_ {__   {___    //
//    {__    {__{__        {__{__           {__    {__{__            {__      {__        {__{__    {__  {__ {__ { {__    //
//    {_______  {__        {__{______       {__    {__{__            {______  {__        {__{_ {__      {__  {__  {__    //
//    {__       {__        {__{__           {__    {__{__            {__      {__        {__{__  {__    {__   {_  {__    //
//    {__         {__     {__ {__           {__    {__ {__   {__     {__        {__     {__ {__    {__  {__       {__    //
//    {__           {____     {________     {__    {__   {____       {__          {____     {__      {__{__       {__    //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract FORM is ERC721Creator {
    constructor() ERC721Creator("Poetic Form", "FORM") {}
}